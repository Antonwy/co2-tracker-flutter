import 'package:co2_tracker/Helper/Entry.dart';

class Entries {

  final List<Entry> entries;

  Entries({this.entries});

  factory Entries.fromJson(List<dynamic> json) {
    return Entries(
      entries: json.map((item) => (
        Entry.fromJsonDetail(item)
      )).toList()
    );
  }


}