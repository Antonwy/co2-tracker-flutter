import 'package:co2_tracker/CustomComponents/CustomAppBar.dart';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Helper/Entry.dart';
import 'package:co2_tracker/Screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Helper/User.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './AddActivityPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  User user;

  AnimationController _controller;
  Animation _animation;
  Animation _secAnimation;
  Animation _thirdAnimation;

  Animation<Offset> _firstOffset;
  Animation<Offset> _secOffset;
  Animation<Offset> _thirdOffset;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _secAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(.3, 1, curve: Curves.easeInOut)));
    _thirdAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(.6, 1, curve: Curves.easeInOut)));

    _firstOffset =
        Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(_controller);
    _secOffset = Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(.3, 1, curve: Curves.easeInOut)));
    _thirdOffset = Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(.6, 1, curve: Curves.easeInOut)));
  }

  Future<void> playAnimtation() async {
    try {
      _controller.reset();
      await _controller.forward();
    } on TickerCanceled {
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "DASHBOARD",
          user: user,
          backButton: false,
        ),
        body: RefreshIndicator(
          onRefresh: reloadPage,
          child: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: fetchUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  user = snapshot.data;
                  return createCardList();
                } else if (snapshot.hasError) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Something went wrong! Check your internet connenction!",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              onPressed: reloadPage,
                              child: Text(
                                "Reload",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            OutlineButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ])
                    ],
                  ));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Loading... Please wait!",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddActivityPage(user: user)));
          },
          child: Icon(
            Icons.add,
            color: Colors.purple,
          ),
          backgroundColor: Colors.white,
          tooltip: "Add Activity",
        ),
      ),
    );
  }

  createCardList() {
    return ListView(
      children: <Widget>[
        headerComponent(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              SlideTransition(
                position: _firstOffset,
                child: ScaleTransition(
                  scale: _animation,
                  child: Card(
                    color: Colors.transparent.withOpacity(0.13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment(-1, 0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Score",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    user.user['score'].toString(),
                                    style: TextStyle(
                                      color: user.user['score'] > 0
                                          ? hexToColor("#80FD98")
                                          : hexToColor("#FF1AB9"),
                                      fontSize: 35,
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "CO2-Points",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.8)),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      user.user['score'] > 0
                                          ? "You're doing great! Save our planet!"
                                          : "Bad score! Use better transportation methods!",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _secOffset,
                child: ScaleTransition(
                  scale: _secAnimation,
                  child: Card(
                    color: Colors.transparent.withOpacity(0.13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment(-1, 0),
                              child: Text(
                                "Score last 5 days",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                          createEntryChart()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _thirdOffset,
                child: ScaleTransition(
                  scale: _thirdAnimation,
                  child: Card(
                    color: Colors.transparent.withOpacity(0.13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment(-1, 0),
                              child: Text(
                                "Transportation",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                          Align(
                              alignment: Alignment(-1, 0),
                              child: Text(
                                "(Last 7 Days)",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(.8)),
                              )),
                          createPieList()
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  createEntryChart() {
    var data = user.entries;

    var series = [
      charts.Series<Entry, String>(
        domainFn: (Entry entry, _) => "${entry.date.day}.${entry.date.month}.",
        measureFn: (Entry entry, _) => entry.score,
        colorFn: (_, __) => charts.Color.fromHex(code: "#FF1AB9"),
        id: 'Entries',
        data: data,
      )
    ];

    return Container(
        height: 200,
        alignment: Alignment(0, 0),
        child: charts.BarChart(series,
            domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.white))),
            primaryMeasureAxis: new charts.NumericAxisSpec(
                renderSpec: new charts.GridlineRendererSpec(
              labelStyle:
                  new charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ))));
  }

  createPieList() {
    var data = user.pieData;

    List<Widget> widgets = data
        .map<Widget>((val) => Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${val.name[0].toUpperCase()}${val.name.substring(1)}:",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    val.amount.toString() + "km",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Divider(
                color: Colors.white.withOpacity(.3),
                height: 20,
              )
            ]))
        .toList();

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(children: widgets),
    );
  }

  headerComponent() {
    return Container(
        alignment: Alignment(0, 0),
        margin: EdgeInsets.symmetric(vertical: 20),
        child: RichText(
            text: TextSpan(style: TextStyle(fontSize: 25), children: [
          TextSpan(text: "Welcome "),
          TextSpan(
              text:
                  "${user.user['username'][0].toUpperCase()}${user.user['username'].substring(1)}",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "!")
        ])));
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<void> reloadPage() async {
    try {
      User user = await fetchUser(anim: false);
      setState(() {
        this.user = user;
      });
    } catch (e) {}
  }

  Future<User> fetchUser({anim = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userID = prefs.get(Constants.USER_ID_KEY);

    final response = await http.get("${Constants.URL}/users/$userID");

    if (anim) playAnimtation();

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load User data!');
    }
  }
}
