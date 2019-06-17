import 'package:intl/intl.dart';

class Entry {
  final int score;
  final DateTime date;

  Entry({this.score, this.date});

  factory Entry.fromJson(Map<String, dynamic> json) {

    String date = json['date'];
    DateFormat format = new DateFormat("EEE MMM d y");

    return Entry(
      score: json['score'],
      date: format.parse(date)
    );
  }




}