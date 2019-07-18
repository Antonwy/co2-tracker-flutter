import 'package:co2_tracker/Helper/Entry.dart';
import 'package:co2_tracker/Helper/PieData.dart';

class User {
  Map<String, dynamic> user;
  List<Entry> entries;
  List<PieData> pieData;
  bool hasData;

  User({this.user, this.entries, this.pieData, this.hasData});

  User.short({Map<String, dynamic> this.user}) {
    entries = new List(0);
    pieData = new List(0);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    var entries = json['entries'] as List;
    List<Entry> entryList = entries.map((i) => Entry.fromJson(i)).toList();

    var pieData = json['pieData'] as List;
    List<PieData> pieList = pieData.map((i) => PieData.fromJson(i)).toList();

    var userData = json['user'];

    DateTime createdAt = DateTime.parse(userData['createdAt']);

    var user = {
      "score": userData['score'],
      "id": userData['_id'],
      "username": userData['username'],
      "email": userData['email'],
      "createdAt": createdAt
    };

    return User(
      user: user,
      entries: entryList,
      pieData: pieList,
      hasData: true
    );
  }

}