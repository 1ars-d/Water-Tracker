import 'package:flutter/material.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/widgets/drinktype_selector.dart';
import '../helpers/calculate_intake.dart';
import '../helpers/helpers.dart';

class HistoryList extends StatelessWidget {
  final List<DrinkAmount> drinkAmounts;
  const HistoryList({required this.drinkAmounts, Key? key}) : super(key: key);

  String formatDate(DateTime date) {
    if (date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year) {
      return "Today";
    }
    return '${date.day} ${parse_month(date.month)} (${parse_day(date.weekday)}.)';
  }

  @override
  Widget build(BuildContext context) {
    drinkAmounts.sort(((a, b) => a.createdDate.compareTo(b.createdDate)));

    Map<String, List<DrinkAmount>> datesMap = {};
    for (var element in drinkAmounts.reversed) {
      String dateString = DateTime(element.createdDate.year,
              element.createdDate.month, element.createdDate.day)
          .toString();
      if (datesMap.containsKey(dateString)) {
        (datesMap[dateString] as List).add(element);
      } else {
        datesMap[dateString] = [element];
      }
    }

    return drinkAmounts.isEmpty
        ? const Center(
            child: Text("No Data",
                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.7))),
          )
        : ListView(
            children: datesMap.entries.map((e) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Color(0xffF9F9F9)),
                    child: Text(
                      formatDate(DateTime.parse(e.key)),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ),
                  ...e.value
                      .map((DrinkAmount amount) => Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                    width: 1),
                              ),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${amount.createdDate.hour.toString().length > 1 ? amount.createdDate.hour.toString() : "0${amount.createdDate.hour}"}:${amount.createdDate.minute.toString().length > 1 ? amount.createdDate.minute.toString() : "0${amount.createdDate.minute}"}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 0.8),
                                        fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        amount.drinkType == "softDrink"
                                            ? "Soft Drink"
                                            : amount.drinkType[0]
                                                    .toUpperCase() +
                                                amount.drinkType.substring(1),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.8),
                                            fontSize: 15),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      amount.drinkType == "softDrink"
                                          ? const Image(
                                              image: AssetImage(
                                                  "assets/IMG/soft_drink.png"),
                                              height: 25,
                                            )
                                          : Image(
                                              image: AssetImage(
                                                  "assets/IMG/${amount.drinkType}.png"),
                                              height: 25,
                                            ),
                                      const SizedBox(width: 15),
                                      Text(
                                        '${amount.amount}${amount.unit}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.8),
                                            fontSize: 16),
                                      )
                                    ],
                                  )
                                ]),
                          ))
                      .toList(),
                ],
              );
            }).toList(),
          );
  }
}
