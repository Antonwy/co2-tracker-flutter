import 'dart:convert';

import 'package:co2_tracker/CustomComponents/CustomAppBar.dart';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/CustomComponents/NumberPicker.dart';
import 'package:co2_tracker/CustomComponents/RadioList.dart';
import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DistancePage extends StatefulWidget {
  final Map<String, dynamic> transportation;
  final User user;

  DistancePage({Key key, this.transportation, this.user}) : super(key: key);

  @override
  _DistancePageState createState() => _DistancePageState();
}

class _DistancePageState extends State<DistancePage> {
  
  int _distance = 10;
  int _sizeVal = 0;
  int _driveVal = 0;
  ColorSchemeHelper colorScheme;

  @override
  void initState() {
    super.initState();
    _distance = getMinValue();
  }

  @override
  Widget build(BuildContext context) {

    colorScheme = Provider.of<ColorSchemeHelper>(context);

    return GradientContainer(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "DISTANCE",
          user: widget.user,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                "Choose your transportation Method:",
                style: colorScheme.textStyle.copyWith(fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Hero(
                    tag: widget.transportation['name'],
                    child: Icon(
                      widget.transportation['icon'],
                      size: 60,
                      color: colorScheme.iconColor,
                    ),
                  )),
                  widget.transportation['id'] == 1
                      ? createCarPicker()
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.transportation['name'],
                          style: colorScheme.textStyle,
                        ),
                        NumberPicker.integer(
                            initialValue: _distance,
                            minValue: getMinValue(),
                            maxValue: getMaxValue(),
                            step: getStepSize(),
                            initText: colorScheme.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                            textStyle: colorScheme.textStyle.copyWith(color: colorScheme.textStyle.color.withOpacity(.8)),
                            onChanged: (item) {
                              setState(() {
                                _distance = item;
                              });
                            }),
                        Text(
                          "KM",
                          style: colorScheme.textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.bottomCenter,
                  child: OutlineButton(
                    onPressed: () async {
                      int type = widget.transportation['id'];
                      int typeID =
                          type == 1 ? type + _driveVal + _sizeVal : type;

                      try {
                        await addActivity(body: {
                          "typeID": typeID,
                          "amount": _distance,
                          "email": widget.user.user['email']
                        });
                      } catch (err) {
                        print(err);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dashboard()));
                    },
                    child: Text("Save", style: colorScheme.textStyle,),
                    splashColor: Colors.white.withOpacity(.2),
                    borderSide: BorderSide(color: colorScheme.iconColor),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  int getMaxValue() {
    switch (widget.transportation['id']) {
      case 10:
        return 5000;
      case 13:
        return 150;
      case 14:
        return 30;
      case 12:
        return 200;
    }
    return 500;
  }

  int getMinValue() {
    switch (widget.transportation['id']) {
      case 10:
        return 200;
      case 13:
        return 0;
      case 14:
        return 0;
      case 12:
        return 0;
    }
    return 0;
  }

  int getStepSize() {
    switch (widget.transportation['id']) {
      case 10:
        return 100;
      case 13:
        return 5;
      case 14:
        return 1;
      case 12:
        return 5;
    }
    return 10;
  }

  createCarPicker() {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Size",
                    style: TextStyle(
                        color: colorScheme.iconColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                RadioList(
                  globalLabelStyle: colorScheme.textStyle,
                  onChanged: changeSize,
                  radioStyle: RadioStyle(
                    borderColor: colorScheme.iconColor,
                    iconColor: colorScheme.fromColor
                  ),
                  radioList: <RadioModel>[
                    RadioModel(
                      defaultClicked: true,
                      value: 0,
                      label: "Small",
                    ),
                    RadioModel(
                      defaultClicked: true,
                      value: 1,
                      label: "Medium"
                    ),
                    RadioModel(
                      value: 2,
                      label: "Large"
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Drive",
                    style: TextStyle(
                        color: colorScheme.iconColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                RadioList(
                  globalLabelStyle: colorScheme.textStyle,
                  onChanged: changeSize,
                  radioStyle: RadioStyle(
                    borderColor: colorScheme.iconColor,
                    iconColor: colorScheme.fromColor
                  ),
                  radioList: <RadioModel>[
                    RadioModel(
                      defaultClicked: true,
                      value: 0,
                      label: "Diesel",
                    ),
                    RadioModel(
                      defaultClicked: true,
                      value: 3,
                      label: "Petrol"
                    ),
                    RadioModel(
                      value: 6,
                      label: "Electro"
                    ),
                  ],
                ),
              ],
            )
          ],
        ));
  }

  changeSize(int value) {
    setState(() {
      _sizeVal = value;
    });
  }

  changeDrive(int value) {
    setState(() {
      _driveVal = value;
    });
  }

  addActivity({Map<String, dynamic> body}) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post("${Constants.URL}/entry/add",
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Something went wrong!");
    }
  }
}
