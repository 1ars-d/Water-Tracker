import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/calculate_intake.dart';

class CalculateDialog extends StatefulWidget {
  final String activeUnit;
  final Function setIntake;
  const CalculateDialog(
      {required this.activeUnit, required this.setIntake, Key? key})
      : super(key: key);

  @override
  CalculateDialogState createState() => CalculateDialogState();
}

class CalculateDialogState extends State<CalculateDialog> {
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool weightIsValid = true;
  bool ageIsValid = true;

  String activeWeightUnit = "kg";

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

  void onSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    final bool calculateiInputDataIsValid = validateWeight() && validateAge();
    if (calculateiInputDataIsValid) {
      int newIntake = calculateIntake(num.parse(weightController.text),
          int.parse(ageController.text), activeWeightUnit, widget.activeUnit);
      prefs.setInt("intake_amount", newIntake).then((value) {
        widget.setIntake(newIntake);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onSubmit(),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
