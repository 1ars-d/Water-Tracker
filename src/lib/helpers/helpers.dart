String parse_day(weekday) {
  if (weekday == DateTime.monday) {
    return "Mo";
  }
  if (weekday == DateTime.tuesday) {
    return "Tue";
  }
  if (weekday == DateTime.wednesday) {
    return "Wed";
  }
  if (weekday == DateTime.thursday) {
    return "Thu";
  }
  if (weekday == DateTime.friday) {
    return "Fri";
  }
  if (weekday == DateTime.saturday) {
    return "Sat";
  }
  if (weekday == DateTime.sunday) {
    return "Sun";
  }
  return "";
}

String parse_month(int month) {
  if (month == 1) {
    return "January";
  }
  if (month == 2) {
    return "February";
  }
  if (month == 3) {
    return "March";
  }
  if (month == 4) {
    return "April";
  }
  if (month == 5) {
    return "May";
  }
  if (month == 6) {
    return "June";
  }
  if (month == 7) {
    return "Juli";
  }
  if (month == 8) {
    return "August";
  }
  if (month == 9) {
    return "September";
  }
  if (month == 10) {
    return "Oktober";
  }
  if (month == 11) {
    return "November";
  }
  if (month == 12) {
    return "Dezember";
  }
  return "";
}
