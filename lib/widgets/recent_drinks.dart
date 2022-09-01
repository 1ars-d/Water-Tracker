import 'package:flutter/material.dart';
import 'package:src/boxes.dart';
import 'package:src/models/DrinkAmount.dart';

import '../helpers/calculate_intake.dart';

class RecentDrinks extends StatelessWidget {
  final Function onAdd;
  final List<DrinkAmount> recentDrinks;

  const RecentDrinks(
      {required this.onAdd, required this.recentDrinks, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: recentDrinks.map((DrinkAmount drink) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              width: 65,
              height: 65,
              child: Material(
                elevation: 5,
                shadowColor: Colors.black12,
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    final drinkAmount = DrinkAmount()
                      ..amount = drink.amount
                      ..unit = drink.unit
                      ..createdDate = drink.createdDate
                      ..drinkType = drink.drinkType;
                    final box = Boxes.getDrinkAmounts();
                    box.add(drinkAmount);
                    onAdd();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(right: 6, left: 6),
                    alignment: Alignment.center,
                    child: drink.drinkType == DrinkType.softDrink.name
                        ? const Image(
                            image: AssetImage("assets/IMG/soft_drink.png"))
                        : Image(
                            image: AssetImage(
                                "assets/IMG/${drink.drinkType}.png")),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              '${drink.amount}${drink.unit}',
              style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
            ),
          ],
        );
      }).toList(),
    );
  }
}
