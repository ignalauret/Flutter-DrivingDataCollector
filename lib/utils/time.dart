class Time {

  static String getTimeStamp() {
    final date = DateTime.now();
    final dateStamp = "${date.day}.${date.month}.${date.year}.${date.hour}.${date.minute}";
    return dateStamp;
  }
}