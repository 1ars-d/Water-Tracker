import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/helpers.dart';
import 'package:src/screens/welcome_screen.dart';
import 'package:src/widgets/calculate_dialog.dart';
import 'package:workmanager/workmanager.dart';

import '../boxes.dart';
import '../widgets/reminder_time_dialog.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String activeUnit = "";
  int _currentGoal = 2000;

  bool notificationsActive = false;
  TimeOfDay selectedStartReminderTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay selectedFinishReminderTime = const TimeOfDay(hour: 21, minute: 0);
  int selectedReminderInterval = 1;

  bool unitIsExpanded = false;
  bool intakeIsExpanded = false;
  bool remindersIsExpanded = false;

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeUnit = prefs.getString("unit") ?? "";
      notificationsActive = prefs.getBool("reminders_active") ?? false;
      selectedStartReminderTime =
          stringToTimeOfDay(prefs.getString("reminder_start_time") ?? "9:00");
      selectedFinishReminderTime =
          stringToTimeOfDay(prefs.getString("reminder_finish_time") ?? "21:00");
      selectedReminderInterval = prefs.getInt("reminder_interval") ?? 1;
      _currentGoal = prefs.getInt("intake_amount") ?? 2000;
    });
  }

  void openReminderDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Container(
                padding: const EdgeInsets.all(20),
                child: ReminderTimeDialog(
                  selectedReminderInterval: selectedReminderInterval,
                  selectedFinishReminderTime: selectedFinishReminderTime,
                  selectedStartReminderTime: selectedStartReminderTime,
                  setEndTime: (TimeOfDay newTime) {
                    setState(() {
                      selectedFinishReminderTime = newTime;
                    });
                  },
                  setStartTime: (TimeOfDay newTime) {
                    setState(() {
                      selectedStartReminderTime = newTime;
                    });
                  },
                  setInterval: (int newInterval) {
                    setState(() {
                      selectedReminderInterval = newInterval;
                    });
                  },
                )),
          );
        }).then(
      (value) async {
        if (value) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt("reminder_interval", selectedReminderInterval);
          prefs.setString("reminder_start_time",
              formatTimeOfDay(selectedStartReminderTime));
          prefs.setString("reminder_finish_time",
              formatTimeOfDay(selectedFinishReminderTime));
          setReminders();
        }
      },
    );
  }

  void setReminders() async {
    await Workmanager().cancelAll();
    await Workmanager()
        .initialize(remindersCallbackDispatcher, isInDebugMode: true);
    await Workmanager().registerPeriodicTask("reminder", "Reminder",
        inputData: {
          "start_hour": selectedStartReminderTime.hour,
          "start_minute": selectedStartReminderTime.minute,
          "finish_hour": selectedFinishReminderTime.hour,
          "finish_minute": selectedFinishReminderTime.minute,
          "init_time": TimeOfDay.now().toString(),
        },
        frequency: getDurationFromIntervalInt(selectedReminderInterval));
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void setUnit(String newUnit) async {
    if (newUnit != activeUnit) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      onChangeUnit(activeUnit, newUnit, prefs);
      prefs.setString("unit", newUnit);
      setState(() {
        _currentGoal = prefs.getInt("intake_amount") ?? 0;
        activeUnit = newUnit;
        intakeIsExpanded = true;
      });
    }
  }

  void setGoal(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("intake_amount", value);
  }

  void showCalculateDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Wrap(
                children: [
                  CalculateDialog(
                    setIntake: (int value) {
                      setState(() {
                        _currentGoal = value;
                      });
                    },
                    activeUnit: activeUnit,
                  ),
                ],
              ),
            ));
  }

  void clearData(context) async {
    final box = Boxes.getDrinkAmounts();
    await box.deleteFromDisk();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await Workmanager().cancelAll();
    Navigator.pushNamedAndRemoveUntil(
        context, WelcomeScreen.routeName, (route) => false);
  }

  void showDeleteDialog(context) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        title: const Text('Delete All Data'),
        content: const Text(
            'Are you sure you want to delete all data. This is not reversable'),
        contentPadding: const EdgeInsets.only(left: 20, bottom: 5, right: 20),
        titlePadding:
            const EdgeInsets.only(top: 20, left: 20, bottom: 5, right: 15),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
                primary: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              clearData(context);
            },
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                primary: Colors.red),
            child: const Text('Delete',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.transparent,

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            title: const Text("Settings"),
            surfaceTintColor: Colors.white,
            shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context, true),
            )),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExpansionPanelList(
              elevation: 1,
              dividerColor: Colors.black12,
              expandedHeaderPadding: const EdgeInsets.all(0),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if (index == 0) {
                    unitIsExpanded = !isExpanded;
                  }
                  if (index == 1) {
                    intakeIsExpanded = !isExpanded;
                  }
                  if (index == 2) {
                    remindersIsExpanded = !remindersIsExpanded;
                  }
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: unitIsExpanded,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text("Unit $activeUnit"),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setUnit("ml");
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: activeUnit == "ml"
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xffEFEFEF),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomLeft: Radius.circular(40)))),
                            child: Text(
                              "ml",
                              style: TextStyle(
                                  color: activeUnit == "ml"
                                      ? Colors.white
                                      : const Color(0xff767676)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setUnit("oz UK");
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: activeUnit == "oz UK"
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xffEFEFEF),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only())),
                            child: Text(
                              "oz UK",
                              style: TextStyle(
                                  color: activeUnit == "oz UK"
                                      ? Colors.white
                                      : const Color(0xff767676)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setUnit("oz US");
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: activeUnit == "oz US"
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xffEFEFEF),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40)))),
                            child: Text(
                              "oz US",
                              style: TextStyle(
                                  color: activeUnit == "oz US"
                                      ? Colors.white
                                      : const Color(0xff767676)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: intakeIsExpanded,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text("Intake Amount"),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NumberPicker(
                                minValue: activeUnit == "ml" ? 50 : 5,
                                maxValue:
                                    activeUnit == "ml" ? 10000000000 : 70000,
                                itemHeight: 50,
                                textStyle: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    fontSize: 18),
                                selectedTextStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Theme.of(context).primaryColor),
                                        top: BorderSide(
                                            width: 1.5,
                                            color: Theme.of(context)
                                                .primaryColor))),
                                value: _currentGoal,
                                step: activeUnit == "ml" ? 50 : 5,
                                haptics: true,
                                onChanged: (value) {
                                  setGoal(value);
                                  setState(() {
                                    _currentGoal = value;
                                  });
                                }),
                            Text(
                              activeUnit,
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => showCalculateDialog(),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text(
                              "Calculate",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: remindersIsExpanded,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text("Reminders"),
                    );
                  },
                  body: Column(
                    children: [
                      SwitchListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          activeColor: Theme.of(context).primaryColor,
                          value: notificationsActive,
                          title: const Text("Activate Reminders"),
                          onChanged: (bool newValue) async {
                            if (newValue) {
                              if (await Permission.notification
                                  .request()
                                  .isGranted) {
                                setState(() {
                                  notificationsActive = newValue;
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool("reminders_active", newValue);
                                setReminders();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please allow notifications in settings for this app")));
                              }
                            } else {
                              setState(() {
                                notificationsActive = newValue;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool("reminders_active", newValue);
                              Workmanager().cancelAll();
                            }
                          }),
                      !notificationsActive
                          ? Container()
                          : SizedBox(
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  openReminderDialog(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(children: [
                                    Text(
                                      "${formatTimeOfDay(selectedStartReminderTime)} - ${formatTimeOfDay(selectedFinishReminderTime)}",
                                      style: const TextStyle(
                                          color: Colors.black87, fontSize: 23),
                                    ),
                                    Text(
                                      getReminderIntervalText(
                                          selectedReminderInterval),
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 12),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, AboutScreen.routeName);
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      overlayColor: MaterialStateProperty.all(Colors.black12),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffefefef)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xff767676),
                        ),
                        Text(
                          "More Information",
                          style: TextStyle(color: Color(0xff767676)),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => showDeleteDialog(context),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      overlayColor: MaterialStateProperty.all(Colors.black12),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                        Text(
                          "Delete All Data",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
