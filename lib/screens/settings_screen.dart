import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/helpers.dart';
import 'package:src/screens/home_screen.dart';
import 'package:src/widgets/calculate_dialog.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String activeUnit = "";
  int _currentGoal = 0;

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeUnit = prefs.getString("unit") ?? "";
      _currentGoal = prefs.getInt("intake_amount") ?? 0;
    });
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
        activeUnit = newUnit;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white,

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
          child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
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
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberPicker(
                    minValue: activeUnit == "ml" ? 100 : 5,
                    maxValue: 10000,
                    itemHeight: 50,
                    textStyle: const TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.3), fontSize: 18),
                    selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.5,
                                color: Theme.of(context).primaryColor),
                            top: BorderSide(
                                width: 1.5,
                                color: Theme.of(context).primaryColor))),
                    value: _currentGoal,
                    step: activeUnit == "ml" ? 100 : 5,
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
                      fontSize: 19, color: Theme.of(context).primaryColor),
                )
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
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffEFEFEF),
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    surfaceTintColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xff767676),
                    ),
                    Text(
                      "More",
                      style: TextStyle(color: Color(0xff767676)),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
