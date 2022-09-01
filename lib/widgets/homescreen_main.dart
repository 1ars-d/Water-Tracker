import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/boxes.dart';
import 'package:src/helpers/helpers.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/screens/settings_screen.dart';
import 'package:src/screens/welcome_screen.dart';
import 'package:src/widgets/progress.dart';
import 'package:src/widgets/recent_drinks.dart';

class HomescreenMain extends StatelessWidget {
  final int todaysDrinkAmount;
  final List<DrinkAmount> drinkAmounts;
  final int prevAmount;
  final int prevIntake;
  final int intakeAmount;
  final bool isActive;
  final bool isSunny;
  final Function sunnyIntakeChange;
  final Function activeIntakeChange;
  final Function onAdd;
  final VoidCallback loadPreferences;
  final String activeUnit;

  const HomescreenMain(
      {required this.prevAmount,
      required this.activeUnit,
      required this.prevIntake,
      required this.intakeAmount,
      required this.isActive,
      required this.isSunny,
      required this.onAdd,
      required this.activeIntakeChange,
      required this.sunnyIntakeChange,
      required this.todaysDrinkAmount,
      required this.drinkAmounts,
      required this.loadPreferences,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: AspectRatio(
            aspectRatio: 1,
            child: Progress(
                activeUnit: activeUnit,
                prevAmount: prevAmount,
                prevIntake: prevIntake,
                intakeAmount: int.parse(intakeAmount.toString()) +
                    (isSunny ? getIntakeChangeDifference(activeUnit) : 0) +
                    (isActive ? getIntakeChangeDifference(activeUnit) : 0),
                todaysAmount: todaysDrinkAmount),
          ),
        ),
        TopActions(
            activeUnit: activeUnit,
            loadPreferences: loadPreferences,
            isSunny: isSunny,
            sunnyIntakeChange: sunnyIntakeChange,
            intakeAmount: intakeAmount,
            isActive: isActive,
            activeIntakeChange: activeIntakeChange),
        Positioned(
          bottom: 50,
          right: 0,
          left: 0,
          child: RecentDrinks(
              onAdd: onAdd,
              recentDrinks: drinkAmounts.length < 2
                  ? drinkAmounts.reversed.toList()
                  : drinkAmounts.length >= 5
                      ? drinkAmounts
                          .sublist(drinkAmounts.length - 4, drinkAmounts.length)
                          .reversed
                          .toList()
                      : drinkAmounts
                          .sublist(0, drinkAmounts.length)
                          .reversed
                          .toList()),
        )
      ],
    );
  }
}

class TopActions extends StatelessWidget {
  final bool isSunny;
  final bool isActive;
  final int intakeAmount;
  final Function sunnyIntakeChange;
  final Function activeIntakeChange;
  final VoidCallback loadPreferences;
  final String activeUnit;

  const TopActions({
    Key? key,
    required this.isSunny,
    required this.activeUnit,
    required this.sunnyIntakeChange,
    required this.intakeAmount,
    required this.isActive,
    required this.activeIntakeChange,
    required this.loadPreferences,
  }) : super(key: key);

  void clearData(context) async {
    final box = Boxes.getDrinkAmounts();
    await box.deleteFromDisk();
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    await prefrences.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, WelcomeScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                isSunny ? Colors.black38 : Colors.transparent,
                            width: 3),
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor),
                    child: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Water Intake: ${isSunny ? "-500" : "+500"}$activeUnit'),
                            behavior: SnackBarBehavior.floating,
                          ));
                          sunnyIntakeChange(intakeAmount, isActive, isSunny);
                        },
                        icon: const Icon(
                          Icons.sunny,
                          color: Colors.white,
                        ))),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                isActive ? Colors.black38 : Colors.transparent,
                            width: 3),
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor),
                    child: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Water Intake: ${isActive ? "-500" : "+500"}$activeUnit'),
                            behavior: SnackBarBehavior.floating,
                          ));
                          activeIntakeChange(intakeAmount, isSunny, isActive);
                        },
                        icon: const Icon(
                          Icons.directions_bike_outlined,
                          color: Colors.white,
                        ))),
              ],
            ),
            ElevatedButton(
                onPressed: () => clearData(context),
                child: const Text("Clear Data")),
            IconButton(
              icon: const Icon(
                Icons.settings,
                size: 30,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
              onPressed: () async {
                final bool result =
                    await Navigator.pushNamed(context, SettingsScreen.routeName)
                        as bool;
                if (result) {
                  loadPreferences();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
