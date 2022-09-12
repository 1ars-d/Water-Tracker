import 'package:flutter/material.dart';
import 'package:src/helpers/helpers.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/screens/about_screen.dart';
import 'package:src/screens/settings_screen.dart';
import 'package:src/widgets/homescreen-widgets/progress.dart';
import 'package:src/widgets/homescreen-widgets/recent_drinks.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          TopActions(
              activeUnit: activeUnit,
              loadPreferences: loadPreferences,
              isSunny: isSunny,
              sunnyIntakeChange: sunnyIntakeChange,
              intakeAmount: intakeAmount,
              isActive: isActive,
              activeIntakeChange: activeIntakeChange),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 450
                          ? MediaQuery.of(context).size.width
                          : 450,
                      height: MediaQuery.of(context).size.width < 450
                          ? MediaQuery.of(context).size.width
                          : 450,
                      child: Progress(
                          activeUnit: activeUnit,
                          prevAmount: prevAmount,
                          prevIntake: prevIntake,
                          intakeAmount: int.parse(intakeAmount.toString()) +
                              (isSunny
                                  ? getIntakeChangeDifference(activeUnit)
                                  : 0) +
                              (isActive
                                  ? getIntakeChangeDifference(activeUnit)
                                  : 0),
                          todaysAmount: todaysDrinkAmount),
                    ),
                    RecentDrinks(
                        onAdd: onAdd,
                        recentDrinks: drinkAmounts.length < 2
                            ? drinkAmounts.reversed.toList()
                            : drinkAmounts.length >= 5
                                ? drinkAmounts
                                    .sublist(drinkAmounts.length - 4,
                                        drinkAmounts.length)
                                    .reversed
                                    .toList()
                                : drinkAmounts
                                    .sublist(0, drinkAmounts.length)
                                    .reversed
                                    .toList()),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          backgroundBlendMode: BlendMode.lighten,
          border: BorderDirectional(
              bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1)))),
      width: MediaQuery.of(context).size.width,
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: isSunny
                                  ? Colors.transparent
                                  : const Color.fromRGBO(0, 0, 0, 0.2)),
                          color: isSunny
                              ? Theme.of(context).primaryColor
                              : Colors.transparent),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          tooltip: "Sunny Day",
                          onPressed: () {
                            if (!isSunny) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Water Intake: ${isSunny ? "-${getIntakeChangeDifference(activeUnit)}" : "+${getIntakeChangeDifference(activeUnit)}"}$activeUnit (hot day)'),
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                            sunnyIntakeChange(intakeAmount, isActive, isSunny);
                          },
                          icon: Icon(
                            Icons.sunny,
                            color: isSunny
                                ? Colors.white
                                : const Color.fromRGBO(0, 0, 0, 0.2),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, right: 10, left: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: isActive
                                  ? Colors.transparent
                                  : const Color.fromRGBO(0, 0, 0, 0.2)),
                          color: isActive
                              ? Theme.of(context).primaryColor
                              : Colors.transparent),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          tooltip: "Active Day",
                          onPressed: () {
                            if (!isActive) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Water Intake: ${isActive ? "-${getIntakeChangeDifference(activeUnit)}" : "+${getIntakeChangeDifference(activeUnit)}"}$activeUnit (active day)'),
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                            activeIntakeChange(intakeAmount, isSunny, isActive);
                          },
                          icon: Icon(
                            Icons.directions_bike_outlined,
                            color: isActive
                                ? Colors.white
                                : const Color.fromRGBO(0, 0, 0, 0.2),
                          ))),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: const FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Today's Progress",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(0, 0, 0, 0.75)),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              child: Theme(
                data: Theme.of(context).copyWith(useMaterial3: false),
                child: PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  elevation: 2,
                  onSelected: (String value) async {
                    switch (value) {
                      case 'About':
                        Navigator.pushNamed(context, AboutScreen.routeName);
                        break;
                      case 'Settings':
                        final bool result = await Navigator.pushNamed(
                            context, SettingsScreen.routeName) as bool;
                        if (result) {
                          loadPreferences();
                        }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  itemBuilder: (BuildContext context) {
                    return {'Settings', 'About'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          horizontalTitleGap: 5,
                          leading: Icon(choice == "Settings"
                              ? Icons.settings
                              : Icons.info_outline),
                          title: Text(choice),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            /* IconButton(
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
            ), */
          ],
        ),
      ),
    );
  }
}
