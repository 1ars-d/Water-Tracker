import 'package:flutter/material.dart';
import 'package:src/boxes.dart';
import 'package:src/helpers/calculate_intake.dart';
import 'package:src/models/DrinkAmount.dart';

class RecentDrinks extends StatelessWidget {
  final Function onAdd;
  final List<DrinkAmount> recentDrinks;

  const RecentDrinks(
      {required this.onAdd, required this.recentDrinks, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: recentDrinks.map((DrinkAmount drink) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  width: 70,
                  height: 110,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(0, 0, 0, 0.05), width: 0),
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.black12,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: Tooltip(
                      message: drink.drinkType,
                      child: InkWell(
                        splashColor:
                            Theme.of(context).primaryColor.withOpacity(0.3),
                        highlightColor:
                            Theme.of(context).primaryColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          final drinkAmount = DrinkAmount()
                            ..amount = drink.amount
                            ..unit = drink.unit
                            ..createdDate = DateTime.now()
                            ..drinkType = drink.drinkType;
                          final box = Boxes.getDrinkAmounts();
                          box.add(drinkAmount);
                          onAdd();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 4),
                          margin: const EdgeInsets.only(right: 6, left: 6),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                padding: const EdgeInsets.all(14),
                                child: drink.drinkType ==
                                        DrinkType.softDrink.name
                                    ? const Image(
                                        image: AssetImage(
                                            "assets/imags/beverages/soft_drink.png"))
                                    : Image(
                                        image: AssetImage(
                                            "assets/images/beverages/${drink.drinkType}.png")),
                              ),
                              Text(
                                '${drink.amount}${drink.unit}',
                                style: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
