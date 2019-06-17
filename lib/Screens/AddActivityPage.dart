import 'package:co2_tracker/CustomComponents/ActivityCard.dart';
import 'package:co2_tracker/CustomComponents/CustomAppBar.dart';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/DistancePage.dart';
import 'package:flutter/material.dart';

class AddActivityPage extends StatefulWidget {
  final User user;

  AddActivityPage({Key key, this.user}) : super(key: key);

  @override
  _AddActivityPageState createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  int id = 1;

  Map<String, dynamic> transportation = {
    "id": 1,
    "icon": Icons.directions_car,
    "name": "Car",
  };

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "ADD ACTIVITY",
          user: widget.user,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(10),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  crossAxisCount: 2,
                  children: createActivityCards(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: OutlineButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DistancePage(
                                transportation: transportation,
                                user: widget.user)));
                  },
                  child: Text("Next"),
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(.2),
                  borderSide: BorderSide(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  createActivityCards() {
    return [
      ActivityCard(
          id: 1,
          icon: Icons.directions_car,
          name: "Car",
          onPressed: handleActivityClicked,
          clickedID: id),
      ActivityCard(
          id: 10,
          icon: Icons.airplanemode_active,
          name: "Plane",
          onPressed: handleActivityClicked,
          clickedID: id),
      ActivityCard(
          id: 13,
          icon: Icons.directions_bike,
          name: "Bike",
          onPressed: handleActivityClicked,
          clickedID: id),
      ActivityCard(
          id: 14,
          icon: Icons.directions_walk,
          name: "Walk",
          onPressed: handleActivityClicked,
          clickedID: id),
      ActivityCard(
          id: 11,
          icon: Icons.train,
          name: "Train",
          onPressed: handleActivityClicked,
          clickedID: id),
      ActivityCard(
          id: 12,
          icon: Icons.directions_bus,
          name: "Bus",
          onPressed: handleActivityClicked,
          clickedID: id),
    ];
  }

  handleActivityClicked(Map<String, dynamic> transportation) {
    this.transportation = transportation;

    setState(() {
      this.id = transportation["id"];
    });
  }
}
