import 'package:intl/intl.dart';

class Entry {
  int score;
  DateTime date;

  int amount;
  String name;
  int typeID;

  Entry.short({this.score, this.date});

  Entry.detail({this.amount, this.name, this.date, this.typeID});

  factory Entry.fromJsonDetail(Map<String, dynamic> json) {
    String date = json['date'];
    DateTime finalDate = DateTime.parse(date);

    return Entry.detail(
      amount: json['amount'],
      name: json['name'],
      date: finalDate,
      typeID: json['typeID']
    );
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    String date = json['date'];
    DateFormat format = new DateFormat("EEE MMM d y");

    return Entry.short(score: json['score'], date: format.parse(date));
  }
}
