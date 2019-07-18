
import 'package:co2_tracker/Helper/Entry.dart';
import 'package:co2_tracker/Helper/PieData.dart';
import 'package:co2_tracker/Helper/User.dart';

class DefaultData {


  User user = User(
    user: {"username": "ABCD", "score": 100},
    entries: <Entry>[],
    pieData: <PieData>[],
    hasData: false
  );


}