import 'package:hive/hive.dart';
import 'package:src/models/DrinkAmount.dart';

class Boxes {
  static Box<DrinkAmount> getDrinkAmounts() => Hive.box('drink_amounts');
}
