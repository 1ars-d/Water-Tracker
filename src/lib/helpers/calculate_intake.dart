int calculate_intake(weight, age, weight_unit, water_unit) {
  int correct_weight = weight;
  if (weight_unit == "lbs") {
    correct_weight = weight * 2.205;
  }
  num result = correct_weight * 30;
  if (water_unit == "oz US") {
    return result ~/ 29.574;
  }
  if (water_unit == "oz UK") {
    return result ~/ 28.413;
  }
  return result.toInt();
}

enum DrinkType {
  water,
  coffee,
  tea,
  juice,
  softDrink,
  milk,
}
