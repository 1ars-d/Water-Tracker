import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src/helpers/calculate_intake.dart';
import 'package:src/models/DrinkAmount.dart';
import 'package:src/widgets/drinktype_selector.dart';

import '../boxes.dart';

class AddModal extends StatefulWidget {
  final Function onAdd;
  const AddModal({required this.onAdd, Key? key}) : super(key: key);

  @override
  _AddModalState createState() => _AddModalState();
}

class _AddModalState extends State<AddModal> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _currentAmount = 0;
  late Future<String> activeUnit;

  DateTime activeDate = DateTime.now();
  TimeOfDay activeTime = TimeOfDay.now();

  DrinkType selectedDrink = DrinkType.water;

  @override
  void initState() {
    activeUnit = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('unit') ?? "";
    });
    super.initState();
  }

  void setSelectedDrink(newDrink) {
    setState(() {
      selectedDrink = newDrink;
    });
  }

  void addHandler(
      int amount, String unit, DateTime createdDate, DrinkType drinkType) {
    final drinkAmount = DrinkAmount()
      ..amount = amount
      ..unit = unit
      ..createdDate = createdDate
      ..drinkType = drinkType.name;
    final box = Boxes.getDrinkAmounts();
    box.add(drinkAmount);
    widget.onAdd();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(children: [
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 7),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromRGBO(0, 0, 0, 0.2)),
              ),
              Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: const Color(0xffE7E7E7)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Row(children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height: 50,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            primary: const Color.fromRGBO(
                                                0, 0, 0, 0.7),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)))),
                                        onPressed: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: activeDate,
                                                  firstDate:
                                                      DateTime(2000, 1, 1),
                                                  lastDate:
                                                      DateTime(2100, 1, 1))
                                              .then((value) {
                                            if (value != null) {
                                              setState(() {
                                                activeDate = value;
                                              });
                                            }
                                          });
                                        },
                                        child: Text((activeDate.day ==
                                                    DateTime.now().day &&
                                                activeDate.month ==
                                                    DateTime.now().month &&
                                                activeDate.year ==
                                                    DateTime.now().year)
                                            ? "Today"
                                            : '${activeDate.day.toString()}/${activeDate.month.toString()}/${activeDate.year.toString()}'),
                                      ),
                                    ))
                              ]),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xffE7E7E7)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(0),
                                      primary:
                                          const Color.fromRGBO(0, 0, 0, 0.7),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: activeTime)
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          activeTime = value;
                                        });
                                      }
                                    });
                                  },
                                  child: Text(
                                      '${activeTime.hour}:${activeTime.minute}'),
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DrinktypeSelector(
                        selectedDrink: selectedDrink,
                        setSelectedDrink: setSelectedDrink,
                      ),
                      FutureBuilder<String>(
                          future: activeUnit,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    NumberPicker(
                                        minValue: 0,
                                        maxValue: 10000,
                                        itemHeight: 50,
                                        textStyle: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.3),
                                            fontSize: 18),
                                        selectedTextStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1.5,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                top: BorderSide(
                                                    width: 1.5,
                                                    color: Theme.of(context)
                                                        .primaryColor))),
                                        value: _currentAmount,
                                        step: snapshot.data == "ml" ? 50 : 5,
                                        haptics: true,
                                        onChanged: (value) {
                                          setState(() {
                                            _currentAmount = value;
                                          });
                                        }),
                                    Text(
                                      snapshot.connectionState !=
                                              ConnectionState.waiting
                                          ? snapshot.data as String
                                          : "",
                                      style: TextStyle(
                                          fontSize: 19,
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: _currentAmount > 0 ? 10 : 0,
                                        shadowColor: const Color.fromARGB(
                                                255, 4, 217, 255)
                                            .withOpacity(.5),
                                        splashFactory: _currentAmount > 0
                                            ? InkRipple.splashFactory
                                            : NoSplash.splashFactory,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        primary: _currentAmount > 0
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).primaryColor),
                                    onPressed: _currentAmount > 0
                                        ? () => addHandler(
                                            _currentAmount,
                                            snapshot.data as String,
                                            DateTime(
                                                activeDate.year,
                                                activeDate.month,
                                                activeDate.day,
                                                activeTime.hour,
                                                activeTime.minute),
                                            selectedDrink)
                                        : () {},
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                )
                              ],
                            );
                          })
                    ],
                  ))
            ],
          ),
        ),
      ]),
    );
  }
}
