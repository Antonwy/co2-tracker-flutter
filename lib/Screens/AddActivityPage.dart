import 'package:co2_tracker/CustomComponents/ActivityCard.dart';
import 'package:co2_tracker/CustomComponents/CustomAppBar.dart';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/DistancePage.dart';
import 'package:co2_tracker/Transitions/AddActivityTransition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddActivityPage extends StatefulWidget {
  final User user;

  AddActivityPage({Key key, this.user}) : super(key: key);

  @override
  _AddActivityPageState createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  int id = 0;
  GlobalKey activeWidgetKey;

  Map<String, dynamic> transportation = {
    "id": 1,
    "icon": Icons.directions_car,
    "name": "Car",
  };

  @override
  Widget build(BuildContext context) {
    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "ADD ACTIVITY",
          user: widget.user,
        ),
        body: Builder(
                  builder: (BuildContext context) {
                    return Container(
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
                      if(id != 0){
                        Navigator.push(
                          context,
                          AddActivityTransition(
                            startWidgetKey: activeWidgetKey,
                            borderRadius: 10.0,
                            duration: Duration(milliseconds: 400),
                              widget: DistancePage(
                                  transportation: transportation,
                                  user: widget.user)));
                      }else {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: Text("Select Transportation Method!"),
                        ));
                      }

                    },
                    child: Text(
                      "Next",
                      style: colorScheme.textStyle,
                    ),
                    splashColor: Colors.white.withOpacity(.2),
                    borderSide: BorderSide(color: colorScheme.iconColor),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                  ),
                )
              ],
            ),
          );
                  }
        ),
      ),
    );
  }

  List<ActivityCard> createActivityCards() {
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

  handleActivityClicked(Map<String, dynamic> transportation, GlobalKey key) {
    this.transportation = transportation;
    this.activeWidgetKey = key;

    setState(() {
      this.id = transportation["id"];
    });
  }
}
