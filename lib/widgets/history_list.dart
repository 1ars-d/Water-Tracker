import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:src/models/DrinkAmount.dart';
import '../boxes.dart';
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
    return '${date.day} ${parseMonth(date.month)} (${parseDay(date.weekday)}.)';
  }

  void showDeleteDialog(context, amount) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        contentPadding: const EdgeInsets.only(left: 20, bottom: 5, right: 20),
        titlePadding:
            const EdgeInsets.only(top: 20, left: 20, bottom: 5, right: 15),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final DrinkAmount backupAmount = DrinkAmount()
                ..amount = amount.amount
                ..unit = amount.unit
                ..createdDate = amount.createdDate
                ..drinkType = amount.drinkType;
              amount.delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Deleted entry"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    final box = Boxes.getDrinkAmounts();
                    box.add(backupAmount);
                  },
                  textColor: Theme.of(context).primaryColor,
                ),
                behavior: SnackBarBehavior.floating,
              ));
            },
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                primary: Theme.of(context).primaryColor),
            child: const Text('Delete',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
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
                      .map((DrinkAmount amount) => Material(
                            color: Colors.white,
                            child: InkWell(
                              onLongPress: () =>
                                  showDeleteDialog(context, amount),
                              child: Container(
                                decoration: const BoxDecoration(
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
                                                    amount.drinkType
                                                        .substring(1),
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8),
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
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8),
                                                fontSize: 16),
                                          )
                                        ],
                                      )
                                    ]),
                              ),
                            ),
                          ))
                      .toList(),
                ],
              );
            }).toList(),
          );
  }
}
