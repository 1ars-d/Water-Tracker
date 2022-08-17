import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/widgets/homescreen_main.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  final List<DrinkAmount> drinksAmounts;
  final Function onAdd;
  final dynamic prevIsSunny;
  final dynamic prevIsActive;
  final Function setPrevIsSunny;
  final Function setPrevIsActive;

  const HomeScreen(
      {required this.prevIsActive,
      required this.prevIsSunny,
      required this.setPrevIsActive,
      required this.setPrevIsSunny,
      required this.onAdd,
      required this.drinksAmounts,
      Key? key})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> intakeAmount;
  late Future<bool> isSunny;
  late Future<bool> isActive;

  int prevIntake = 0;

  @override
  void initState() {
    intakeAmount = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('intake_amount') ?? 0;
    });
    isSunny = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool(
              '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}_isSunny') ??
          false;
    });
    isActive = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool(
              '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}_isActive') ??
          false;
    });
    super.initState();
  }

  void setActive(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(
        '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}_isActive',
        value);
    widget.setPrevIsActive(!value);
    setState(() {
      isActive = Future(() => value);
    });
  }

  void setSunny(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(
        '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}_isSunny',
        value);
    widget.setPrevIsSunny(!value);
    setState(() {
      isSunny = Future(() => value);
    });
  }

  void activeIntakeChange(snapshot, sunnySnapshot, activeSnapshot) {
    setState(() {
      if (sunnySnapshot.data as bool) {
        if (activeSnapshot.data as bool) {
          prevIntake = (snapshot.data as int) + 1000;
        } else {
          prevIntake = (snapshot.data as int) + 500;
        }
      } else {
        if (activeSnapshot.data as bool) {
          prevIntake = (snapshot.data as int) + 500;
        } else {
          prevIntake = (snapshot.data as int);
        }
      }
      setActive(!(activeSnapshot.data as bool));
    });
  }

  void sunnyIntakeChange(snapshot, activeSnapshot, sunnySnapshot) {
    setState(() {
      if (activeSnapshot.data as bool) {
        if (sunnySnapshot.data as bool) {
          prevIntake = (snapshot.data as int) + 1000;
        } else {
          prevIntake = (snapshot.data as int) + 500;
        }
      } else {
        if (sunnySnapshot.data as bool) {
          prevIntake = (snapshot.data as int) + 500;
        } else {
          prevIntake = (snapshot.data as int);
        }
      }
      setSunny(!(sunnySnapshot.data as bool));
    });
  }

  @override
  Widget build(BuildContext context) {
    final amountsList = widget.drinksAmounts.map((DrinkAmount element) {
      if (element.createdDate.year == DateTime.now().year &&
          element.createdDate.month == DateTime.now().month &&
          element.createdDate.day == DateTime.now().day) {
        return element.amount;
      } else {
        return 0;
      }
    }).toList();

    final int todaysDrinkAmount = amountsList.isNotEmpty
        ? amountsList.reduce((value, e) => value + e)
        : 0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Color.fromRGBO(0, 0, 0, 0.02),

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: Center(
          child: FutureBuilder<bool>(
        future: isActive,
        builder: (activeCtx, activeSnapshot) {
          return FutureBuilder<bool>(
              future: isSunny,
              builder: (sunnyCtx, sunnySnapshot) {
                return FutureBuilder<int>(
                    future: intakeAmount,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            bool usePrevIsActive =
                                widget.prevIsActive ?? activeSnapshot.data;
                            bool usePrevIsSunny =
                                widget.prevIsSunny ?? sunnySnapshot.data;
                            int prevAmount = todaysDrinkAmount;
                            int usePrevIntake = prevIntake;
                            if (usePrevIsActive == activeSnapshot.data &&
                                usePrevIsSunny == sunnySnapshot.data) {
                              prevAmount = todaysDrinkAmount -
                                  (amountsList.isNotEmpty
                                      ? amountsList.last
                                      : 0);
                              usePrevIntake = (snapshot.data as int) +
                                  (activeSnapshot.data as bool ? 500 : 0) +
                                  (sunnySnapshot.data as bool ? 500 : 0);
                            }
                            return HomescreenMain(
                              onAdd: widget.onAdd,
                              drinkAmounts: widget.drinksAmounts,
                              prevAmount: prevAmount,
                              prevIntake: usePrevIntake,
                              snapshot: snapshot,
                              activeSnapshot: activeSnapshot,
                              sunnySnapshot: sunnySnapshot,
                              activeIntakeChange: activeIntakeChange,
                              sunnyIntakeChange: sunnyIntakeChange,
                              todaysDrinkAmount: todaysDrinkAmount,
                            );
                          }
                      }
                    });
              });
        },
      )),
    );
  }
}
