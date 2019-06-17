import 'package:co2_tracker/Helper/Entry.dart';
import 'package:co2_tracker/Helper/PieData.dart';

class User {
  Map<String, dynamic> user;
  List<Entry> entries;
  List<PieData> pieData;

  User({this.user, this.entries, this.pieData});

  User.short({Map<String, dynamic> this.user}) {
    entries = new List(0);
    pieData = new List(0);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    var entries = json['entries'] as List;
    List<Entry> entryList = entries.map((i) => Entry.fromJson(i)).toList();

    var pieData = json['pieData'] as List;
    List<PieData> pieList = pieData.map((i) => PieData.fromJson(i)).toList();

    return User(
      user: json['user'],
      entries: entryList,
      pieData: pieList,
    );
  }




}