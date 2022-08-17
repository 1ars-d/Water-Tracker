import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/calculate_intake.dart';
import 'package:src/screens/home_screen.dart';

import '../models/DrinkAmount.dart';

class SetupScreen extends StatefulWidget {
  static const routeName = "/setup";

  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String activeUnit = "ml";
  String activeWeightUnit = "kg";

  TextEditingController weightController = TextEditingController(text: "0");
  TextEditingController ageController = TextEditingController(text: "0");
  bool weightIsValid = true;
  bool ageIsValid = true;

  int _currentGoal = 2000;
  int activeTabIndex = 0;

  @override
  void initState() {
    Hive.openBox<DrinkAmount>('drink_amounts');
    super.initState();
  }

  bool validateWeight() {
    if (weightController.text.isEmpty || int.parse(weightController.text) < 1) {
      setState(() {
        weightIsValid = false;
      });
      return false;
    }
    setState(() {
      weightIsValid = true;
    });
    return true;
  }

  bool validateAge() {
    if (ageController.text.isEmpty || int.parse(ageController.text) < 1) {
      setState(() {
        ageIsValid = false;
      });
      return false;
    }
    setState(() {
      ageIsValid = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final finishButton = ElevatedButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          if (activeTabIndex == 0 && validateWeight() && validateAge()) {
            prefs.setString("unit", activeUnit);
            await prefs
                .setInt(
                    "intake_amount",
                    calculate_intake(
                        num.parse(weightController.text),
                        int.parse(ageController.text),
                        activeWeightUnit,
                        activeUnit))
                .then((value) => Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (_) => false));
          } else if (activeTabIndex == 1) {
            prefs.setString("unit", activeUnit);
            prefs.setInt("intake_amount", _currentGoal).then((value) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (_) => false));
          }
        },
        style:
            ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
        child: Text(
          activeTabIndex == 0 ? "Calculate and Finish" : "Finish",
          style: const TextStyle(
              fontSize: 19, color: Colors.white, fontWeight: FontWeight.w600),
        ));

    final unitSelection = Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Unit",
              style: TextStyle(fontSize: 22, color: Color(0xFF3B3B3B)),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding:
                  const EdgeInsets.only(right: 20, left: 15, top: 4, bottom: 4),
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 3)
              ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: DropdownButton<String>(
                value: activeUnit,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 40,
                  color: Color(0xffD9D9D9),
                ),
                elevation: 1,
                underline: Container(),
                borderRadius: BorderRadius.circular(5),
                style: const TextStyle(color: Color(0xff575757), fontSize: 18),
                onChanged: (String? newValue) {
                  setState(() {
                    activeUnit = newValue!;
                  });
                },
                items: <String>['ml', 'oz UK', 'oz US']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ));

    final calculateSide = Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select your Weight",
              style: TextStyle(fontSize: 20, color: Color(0xFF3B3B3B)),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  height: 55,
                  width: 150,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (_) {
                      validateWeight();
                    },
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w100),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 30),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: weightIsValid
                                  ? Theme.of(context).primaryColor
                                  : Colors.redAccent.shade200,
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: weightIsValid
                                  ? Colors.white
                                  : Colors.redAccent.shade200,
                              width: 2),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    controller: weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.only(
                      right: 20, left: 15, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 3)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                    value: activeWeightUnit,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: Color(0xffD9D9D9),
                    ),
                    elevation: 1,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(5),
                    style:
                        const TextStyle(color: Color(0xff575757), fontSize: 18),
                    onChanged: (String? newValue) {
                      setState(() {
                        activeWeightUnit = newValue!;
                      });
                    },
                    items: <String>['kg', 'lbs']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Select your Age",
              style: TextStyle(fontSize: 20, color: Color(0xFF3B3B3B)),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 55,
                  width: 120,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: TextField(
                    onChanged: (_) => validateAge(),
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w100),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 30),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: ageIsValid
                                  ? Theme.of(context).primaryColor
                                  : Colors.redAccent.shade200,
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ageIsValid
                                  ? Colors.white
                                  : Colors.redAccent.shade200,
                              width: 2),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    controller: ageController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  "Years",
                  style: TextStyle(fontSize: 18, color: Color(0xFF3B3B3B)),
                ),
              ],
            )
          ],
        ));

    final manualSide = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select your Goal manually",
            style: TextStyle(fontSize: 20, color: Color(0xFF3B3B3B)),
          ),
          Row(
            children: [
              NumberPicker(
                  minValue: 100,
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
                  step: 100,
                  haptics: true,
                  onChanged: (value) {
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
          )
        ],
      ),
    );

    final tabBar = Column(
      children: [
        TabBar(
          onTap: (value) {
            setState(() {
              activeTabIndex = value;
            });
          },
          indicatorColor: Theme.of(context).primaryColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.normal),
          unselectedLabelColor: const Color(0xff8C8C8C),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 19),
          labelPadding: const EdgeInsets.only(bottom: 5),
          tabs: const [
            Tab(
              text: "Calculate",
            ),
            Tab(
              text: "Manual",
            )
          ],
        ),
        SizedBox(
            height: 400,
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [calculateSide, manualSide]))
      ],
    );

    return Scaffold(
        /* appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Setup",
            style: TextStyle(color: Colors.white),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,

            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.light, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          backgroundColor: Theme.of(context).primaryColor,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black12,
          elevation: 3,
        ), */
        body: DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height - 100,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      unitSelection,
                      tabBar,
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: finishButton,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
