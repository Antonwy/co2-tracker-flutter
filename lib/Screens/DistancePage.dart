import 'dart:convert';

import 'package:co2_tracker/CustomComponents/CustomAppBar.dart';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/CustomComponents/NumberPicker.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _distance = getMinValue();
  }

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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
                      color: Colors.white,
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
                          style: TextStyle(color: Colors.white),
                        ),
                        NumberPicker.integer(
                            initialValue: _distance,
                            minValue: getMinValue(),
                            maxValue: getMaxValue(),
                            step: getStepSize(),
                            onChanged: (item) {
                              setState(() {
                                _distance = item;
                              });
                            }),
                        Text(
                          "KM",
                          style: TextStyle(color: Colors.white),
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
                      print('Type: ' +
                          (type == 1 ? type + _driveVal + _sizeVal : type)
                              .toString());

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
                    child: Text("Save"),
                    textColor: Colors.white,
                    splashColor: Colors.white.withOpacity(.2),
                    borderSide: BorderSide(color: Colors.white),
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
    print(widget.transportation['id']);
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

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
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
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Size",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _sizeVal,
                      onChanged: changeSize,
                      activeColor: Colors.white,
                    ),
                    Text(
                      "Small",
                      style: TextStyle(
                          color: _sizeVal == 0
                              ? Colors.white
                              : Colors.white.withOpacity(.7)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _sizeVal,
                      onChanged: changeSize,
                      activeColor: Colors.white,
                    ),
                    Text(
                      "Medium",
                      style: TextStyle(
                          color: _sizeVal == 1
                              ? Colors.white
                              : Colors.white.withOpacity(.7)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 2,
                      groupValue: _sizeVal,
                      onChanged: changeSize,
                      activeColor: Colors.white,
                    ),
                    Text(
                      "Large",
                      style: TextStyle(
                          color: _sizeVal == 2
                              ? Colors.white
                              : Colors.white.withOpacity(.7)),
                    )
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Drive",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _driveVal,
                      onChanged: changeDrive,
                      activeColor: Colors.white,
                    ),
                    Text(
                      "Diesel",
                      style: TextStyle(
                          color: _driveVal == 0
                              ? Colors.white
                              : Colors.white.withOpacity(.7)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 3,
                      groupValue: _driveVal,
                      onChanged: changeDrive,
                      activeColor: Colors.white,
                    ),
                    Text(
                      "Petrol",
                      style: TextStyle(
                          color: _driveVal == 3
                              ? Colors.white
                              : Colors.white.withOpacity(.7)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 6,
                      groupValue: _driveVal,
                      onChanged: changeDrive,
                      activeColor: Colors.white,
                    ),
                    Text(
                      "Electro",
                      style: TextStyle(
                          color: _driveVal == 6
                              ? Colors.white
                              : Colors.white.withOpacity(.7)),
                    )
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
    print(response.body);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Something went wrong!");
    }
  }
}
