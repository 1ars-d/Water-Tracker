// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:src/boxes.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/screens/home_screen.dart';
import 'package:src/screens/statistics_screen.dart';
import 'package:src/widgets/add_modal.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:src/widgets/nav_bar.dart';

class NavigationController extends StatefulWidget {
  final int initIndex;

  const NavigationController({this.initIndex = 0, Key? key}) : super(key: key);

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int activeIndex = 0;
  final iconsList = [Icons.apps, Icons.bar_chart];
  var prevIsSunny;
  var prevIsActive;

  void setPrevIsActive(value) {
    setState(() {
      prevIsActive = value;
    });
  }

  void onAdd() {
    setPrevIsActive(null);
    setPrevIsSunny(null);
  }

  void setPrevIsSunny(value) {
    setState(() {
      prevIsSunny = value;
    });
  }

  @override
  void initState() {
    activeIndex = widget.initIndex;
    super.initState();
  }

  void setPage(index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: activeIndex,
        children: [
          ValueListenableBuilder<Box<DrinkAmount>>(
              valueListenable: Boxes.getDrinkAmounts().listenable(),
              builder: (context, box, _) {
                final drinkAmounts = box.values.toList().cast<DrinkAmount>();
                return HomeScreen(
                  onAdd: onAdd,
                  prevIsActive: prevIsActive,
                  prevIsSunny: prevIsActive,
                  setPrevIsActive: setPrevIsActive,
                  setPrevIsSunny: setPrevIsSunny,
                  drinksAmounts: drinkAmounts,
                );
              }),
          ValueListenableBuilder<Box<DrinkAmount>>(
              valueListenable: Boxes.getDrinkAmounts().listenable(),
              builder: (context, box, _) {
                final drinkAmounts = box.values.toList().cast<DrinkAmount>();
                return StatisticsScreen(
                  drinksAmounts: drinkAmounts,
                );
              }),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                elevation: 10,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                context: context,
                builder: (ctx) {
                  return AddModal(onAdd: onAdd);
                });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavBar(
        activeIndex: activeIndex,
        setPage: setPage,
      ),
    );
  }
}
