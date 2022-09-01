import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  NavigationControllerState createState() => NavigationControllerState();
}

class NavigationControllerState extends State<NavigationController> {
  int activeIndex = 0;
  final iconsList = [Icons.apps, Icons.bar_chart];
  dynamic prevIsSunny;
  dynamic prevIsActive;

  String activeUnit = "";
  bool isSunny = false;
  bool isActive = false;
  int intakeAmount = 0;

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

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeUnit = prefs.getString("unit") ?? "";
      intakeAmount = prefs.getInt('intake_amount') ?? 0;
      isSunny = prefs.getBool(
              '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}_isSunny') ??
          false;
      isActive = prefs.getBool(
              '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}_isActive') ??
          false;
    });
  }

  @override
  void initState() {
    activeIndex = widget.initIndex;
    super.initState();
    loadPreferences();
  }

  void setPage(index) {
    setState(() {
      activeIndex = index;
    });
  }

  void createModal() {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (ctx) {
          return AddModal(onAdd: onAdd);
        });
  }

  void changeActive(value) {
    setState(() {
      isActive = value;
    });
  }

  void changeSunny(value) {
    setState(() {
      isSunny = value;
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
                  changeActive: changeActive,
                  changeSunny: changeSunny,
                  loadPreferences: loadPreferences,
                  activeUnit: activeUnit,
                  intakeAmount: intakeAmount,
                  isSunny: isSunny,
                  isActive: isActive,
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
                  activeUnit: activeUnit,
                  intakeAmount: intakeAmount,
                  drinksAmounts: drinkAmounts,
                );
              })
        ],
      ),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: createModal,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
