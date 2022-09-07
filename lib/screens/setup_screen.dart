import 'package:flutter/material.dart';
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
  String activeUnit = "";
  String activeWeightUnit = "kg";

  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool weightIsValid = true;
  bool ageIsValid = true;

  int _currentGoal = 100;
  int activeTabIndex = 0;
  bool unitIsValid = true;

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

  bool validateUnit() {
    if (activeUnit != "") {
      setState(() {
        unitIsValid = true;
      });
      return true;
    } else {
      setState(() {
        unitIsValid = false;
      });
      return false;
    }
  }

  void onSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    if (validateUnit()) {
      final bool calculateiInputDataIsValid = validateWeight() && validateAge();
      if (activeTabIndex == 0 && calculateiInputDataIsValid) {
        prefs.setString("unit", activeUnit);
        prefs
            .setInt(
                "intake_amount",
                calculateIntake(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitSelection = Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: activeUnit == "" ? null : activeUnit,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 30,
                color: Color(0xffD9D9D9),
              ),
              dropdownColor: Colors.white,
              underline: Container(
                color: !unitIsValid
                    ? Colors.red
                    : activeUnit != ""
                        ? Theme.of(context).primaryColor
                        : Colors.black26,
                height: 1,
              ),
              borderRadius: BorderRadius.circular(5),
              onChanged: (String? newValue) {
                setState(() {
                  activeUnit = newValue!;
                  unitIsValid = true;
                  if (newValue == "ml") {
                    _currentGoal = 100;
                  } else {
                    _currentGoal = 5;
                  }
                });
              },
              elevation: 1,
              hint: const Text("Choose Unit"),
              items: <String>['ml', 'oz UK', 'oz US']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
              style: TextStyle(fontSize: 18, color: Color(0xFF3B3B3B)),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  height: 55,
                  width: 150,
                  child: TextField(
                    onChanged: (_) {
                      validateWeight();
                    },
                    decoration: InputDecoration(
                      label: const Text("Weight"),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: weightIsValid
                                ? Theme.of(context).primaryColor
                                : Colors.red,
                            width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: weightIsValid
                                ? const Color(0xffD9D9D9)
                                : Colors.red,
                            width: 1.5),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.normal),
                    controller: weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton<String>(
                  value: activeWeightUnit,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                    color: Color(0xffD9D9D9),
                  ),
                  elevation: 1,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                SizedBox(
                  height: 55,
                  width: 120,
                  child: TextField(
                    onChanged: (_) => validateAge(),
                    decoration: InputDecoration(
                      label: const Text("Age"),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ageIsValid
                                ? Theme.of(context).primaryColor
                                : Colors.red,
                            width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ageIsValid
                                ? const Color(0xffD9D9D9)
                                : Colors.red,
                            width: 1.5),
                      ),
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
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Your weight and age are only used for the calculation and will not be saved.",
              style:
                  TextStyle(fontSize: 13, color: Color.fromRGBO(0, 0, 0, 0.5)),
            )
          ],
        ));

    final manualSide = Padding(
      padding: const EdgeInsets.all(20),
      child: activeUnit == ""
          ? const Center(child: Text("Please select a unit"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select your Goal manually",
                  style: TextStyle(fontSize: 18, color: Color(0xFF3B3B3B)),
                ),
                Row(
                  children: [
                    NumberPicker(
                        minValue: activeUnit == "ml" ? 100 : 5,
                        maxValue: 10000,
                        itemHeight: 50,
                        textStyle: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.3), fontSize: 18),
                        selectedTextStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
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
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: onSubmit,
          backgroundColor: Theme.of(context).primaryColor,
          icon: Text(
            activeTabIndex == 0 ? "Finish" : "Finish",
            style: const TextStyle(
                fontSize: 19, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          extendedIconLabelSpacing: 15,
          label: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
        body: DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Setup",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff3F3D56)),
                                ),
                                Text(
                                  "Setup your weight and age to calculate your water intake, or choose it manually",
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6)),
                                )
                              ],
                            ),
                          ),
                          unitSelection,
                          tabBar,
                        ]),
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ),
        ));
  }
}
