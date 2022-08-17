import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/boxes.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/screens/welcome_screen.dart';
import 'package:src/widgets/progress.dart';
import 'package:src/widgets/recent_drinks.dart';

class HomescreenMain extends StatelessWidget {
  final int todaysDrinkAmount;
  final List<DrinkAmount> drinkAmounts;
  final int prevAmount;
  final int prevIntake;
  final AsyncSnapshot<int> snapshot;
  final AsyncSnapshot<bool> activeSnapshot;
  final AsyncSnapshot<bool> sunnySnapshot;
  final Function sunnyIntakeChange;
  final Function activeIntakeChange;
  final Function onAdd;

  const HomescreenMain(
      {required this.prevAmount,
      required this.prevIntake,
      required this.snapshot,
      required this.activeSnapshot,
      required this.sunnySnapshot,
      required this.onAdd,
      required this.activeIntakeChange,
      required this.sunnyIntakeChange,
      required this.todaysDrinkAmount,
      required this.drinkAmounts,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Progress(
            prevAmount: prevAmount,
            prevIntake: prevIntake,
            intakeAmount: int.parse(snapshot.data.toString()) +
                (sunnySnapshot.connectionState == ConnectionState.done &&
                        sunnySnapshot.data as bool
                    ? 500
                    : 0) +
                (activeSnapshot.connectionState == ConnectionState.done &&
                        activeSnapshot.data as bool
                    ? 500
                    : 0),
            todaysAmount: todaysDrinkAmount),
        TopActions(
            sunny_snapshot: sunnySnapshot,
            sunnyIntakeChange: sunnyIntakeChange,
            snapshot: snapshot,
            active_snapshot: activeSnapshot,
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
  const TopActions({
    Key? key,
    required this.sunny_snapshot,
    required this.sunnyIntakeChange,
    required this.snapshot,
    required this.active_snapshot,
    required this.activeIntakeChange,
  }) : super(key: key);

  final AsyncSnapshot<bool> sunny_snapshot;
  final Function sunnyIntakeChange;
  final AsyncSnapshot<int> snapshot;
  final AsyncSnapshot<bool> active_snapshot;
  final Function activeIntakeChange;

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
                            color: sunny_snapshot.connectionState ==
                                        ConnectionState.done &&
                                    sunny_snapshot.data as bool
                                ? Colors.black38
                                : Colors.transparent,
                            width: 3),
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor),
                    child: IconButton(
                        onPressed: sunny_snapshot.connectionState ==
                                ConnectionState.done
                            ? () => sunnyIntakeChange(
                                snapshot, active_snapshot, sunny_snapshot)
                            : () {},
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
                            color: active_snapshot.connectionState ==
                                        ConnectionState.done &&
                                    active_snapshot.data as bool
                                ? Colors.black38
                                : Colors.transparent,
                            width: 3),
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor),
                    child: IconButton(
                        onPressed: active_snapshot.connectionState ==
                                ConnectionState.done
                            ? () => activeIntakeChange(
                                snapshot, sunny_snapshot, active_snapshot)
                            : () {},
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
              onPressed: () {
                print("Hello");
              },
            ),
          ],
        ),
      ),
    );
  }
}
