import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/widgets/history_list.dart';
import 'package:src/widgets/statistics_chart.dart';

import '../models/DrinkAmount.dart';

class StatisticsScreen extends StatefulWidget {
  static const routeName = "/statistics";
  final List<DrinkAmount> drinksAmounts;

  StatisticsScreen({required this.drinksAmounts, Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late Future<String> activeUnit;
  late Future<int> intakeAmount;

  @override
  void initState() {
    activeUnit = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('unit') ?? "";
    });
    intakeAmount = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('intake_amount') ?? 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<int> data = [0, 0, 0, 0, 0, 0, 0];
    for (var element in widget.drinksAmounts.reversed) {
      for (var i = 0; i <= 6; i++) {
        DateTime date = DateTime.now().subtract(Duration(days: i));
        if (element.createdDate.year == date.year &&
            element.createdDate.month == date.month &&
            element.createdDate.day == date.day) {
          data[6 - i] += element.amount;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Statistics"),
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 40,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          FutureBuilder<String>(
            future: activeUnit,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return FutureBuilder<int>(
                  builder: (intakeContext, intakeSnapshot) {
                    if (intakeSnapshot.connectionState !=
                        ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Last Week",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 230,
                              child: StatisticsChart(
                                data: data,
                                intakeAmount: intakeSnapshot.data as int,
                                activeUnit: snapshot.data as String,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  future: intakeAmount,
                );
              }
              return Container();
            },
            initialData: "ml",
          ),
          Expanded(child: HistoryList(drinkAmounts: widget.drinksAmounts))
        ]),
      ),
    );
  }
}
