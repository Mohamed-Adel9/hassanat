String? convertTimeTo12HourFormat(String? time24) {
  List<String> parts = time24!.split(":");
  int hour = int.parse(parts[0]);
  int minutes = int.parse(parts[1].split(' ')[0]);
  String suffix = hour >= 12 ? "PM" : "AM";
  int hour12 = hour % 12 == 0
      ? 12
      : hour % 12; // Convert hour from 24-hour to 12-hour format

  String minutesString = minutes < 10 ? '0$minutes' : '$minutes';
  return '$hour12:$minutesString $suffix';
}
