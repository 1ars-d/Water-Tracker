import 'package:flutter/material.dart';
import 'package:src/helpers/calculate_intake.dart';

class DrinktypeSelector extends StatelessWidget {
  final DrinkType selectedDrink;
  final Function setSelectedDrink;

  const DrinktypeSelector(
      {required this.selectedDrink, required this.setSelectedDrink, Key? key})
      : super(key: key);

  final Map<String, DrinkType> drinks = const {
    "water": DrinkType.water,
    "coffee": DrinkType.coffee,
    "tea": DrinkType.tea,
    "juice": DrinkType.juice,
    "soft drink": DrinkType.softDrink,
    "milk": DrinkType.milk,
  };

  static ColorFilter greyscale = const ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: 105,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: drinks.entries.map((entry) {
          return InkWell(
            splashColor: Theme.of(context).primaryColor.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
            onTap: () => setSelectedDrink(entry.value),
            child: Container(
              padding: const EdgeInsets.only(right: 8, left: 8, top: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(11),
                      height: 65,
                      alignment: Alignment.center,
                      width: 65,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: selectedDrink == entry.value
                              ? Border.all(
                                  color: selectedDrink == entry.value
                                      ? Theme.of(context).primaryColor
                                      : const Color.fromRGBO(0, 0, 0, 0.2),
                                  width: selectedDrink == entry.value ? 3 : 3)
                              : Border.all(
                                  width: 3, color: Colors.transparent)),
                      child: selectedDrink == entry.value
                          ? entry.value == DrinkType.softDrink
                              ? const Image(
                                  image:
                                      AssetImage("assets/IMG/soft_drink.png"))
                              : Image(
                                  image:
                                      AssetImage("assets/IMG/${entry.key}.png"))
                          : ColorFiltered(
                              colorFilter: greyscale,
                              child: entry.value == DrinkType.softDrink
                                  ? const Image(
                                      image: AssetImage(
                                          "assets/IMG/soft_drink.png"))
                                  : Image(
                                      image: AssetImage(
                                          "assets/IMG/${entry.key}.png")),
                            )),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    entry.key,
                    style: TextStyle(
                        color: selectedDrink == entry.value
                            ? Theme.of(context).primaryColor
                            : const Color.fromRGBO(0, 0, 0, 0.4)),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
