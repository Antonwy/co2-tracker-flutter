import 'package:co2_tracker/CustomComponents/Chart.dart';
import 'package:co2_tracker/CustomComponents/CustomAppBar.dart';
import 'package:co2_tracker/CustomComponents/CustomCard.dart';
import 'package:co2_tracker/CustomComponents/CustomFabTips.dart';
import 'package:co2_tracker/CustomComponents/CustomText.dart';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Helper/DefaultData.dart';
import 'package:co2_tracker/Helper/Entries.dart';
import 'package:co2_tracker/Screens/LoginPage.dart';
import 'package:co2_tracker/Screens/ProfilePage.dart';
import 'package:co2_tracker/Screens/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Helper/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Helper/HelperMethods.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  User user = DefaultData().user;
  bool fetchingError = false;

  bool showTips = false;
  bool appBarIsElevated = false;
  bool hasData = false;

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (!appBarIsElevated && _scrollController.offset >= 50.0) {
          setState(() {
            appBarIsElevated = true;
          });
        } else if (appBarIsElevated && _scrollController.offset < 50.0) {
          setState(() {
            appBarIsElevated = false;
          });
        }
      });

    fetchUser(anim: true);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  ColorSchemeHelper colorScheme;

  @override
  Widget build(BuildContext context) {
    colorScheme = Provider.of<ColorSchemeHelper>(context);

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "DASHBOARD",
          user: user,
          elevated: appBarIsElevated,
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: fetchUser,
          child: ListView(
            controller: _scrollController,
            children: createCardList(context),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CustomFabTips(
          user: user,
          showTips: showTips,
          size: MediaQuery.of(context).size,
          toggle: toggleTips,
          // size: Size(105, 35)
        ),
        drawer: Drawer(
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
                color: colorScheme.fromColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        user != null
                            ? "Hey ${user.user['username'][0].toUpperCase()}${user.user['username'].substring(1)}"
                            : "HEY",
                        style: colorScheme.textStyle.copyWith(fontSize: 25),
                      )),
                  decoration: BoxDecoration(color: colorScheme.toColor),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: colorScheme.iconColor,
                  ),
                  title: Text(
                    "Profile",
                    style: colorScheme.textStyle,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  user: user,
                                )));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: colorScheme.iconColor,
                  ),
                  title: Text(
                    "Settings",
                    style: colorScheme.textStyle,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createCardList(context) {
    if (user == null && !fetchingError) {
      return <Widget>[
        headerComponent(),
        Container(
          height: MediaQuery.of(context).size.height,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Loading... Please wait!",
              style: colorScheme.textStyle,
            )
          ]),
        )
      ];
    } else if (!fetchingError) {
      return <Widget>[
        headerComponent(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              CustomCard(
                delay: 0,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(-1, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CustomText(
                                "Score",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                loading: !user.hasData,
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
                            child: CustomText(
                              user.user['score'].toString(),
                              style: TextStyle(
                                color: user.user['score'] >= 0
                                    ? hexToColor("#80FD98")
                                    : hexToColor("#FF1AB9"),
                                fontSize: 35,
                              ),
                              loading: !user.hasData,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: CustomText(
                              "CO2-Points",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8)),
                              loading: !user.hasData,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.bottomLeft,
                              child: CustomText(
                                user.user['score'] >= 0
                                    ? "You're doing great! Save our planet!"
                                    : "Bad score! Use better transportation methods!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                loading: !user.hasData,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              CustomCard(
                delay: 250,
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment(-1, 0),
                        child: CustomText(
                          user.entries.length == 0 && user.hasData
                              ? "No history until now."
                              : "Score last ${user.entries.length} days",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          loading: !user.hasData,
                        )),
                    Align(
                        alignment: Alignment(-1, 0),
                        child: CustomText(
                          user.entries.length != 0
                              ? '(Click on a bar to see more.)'
                              : '',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(.8)),
                          loading: !user.hasData,
                        )),
                    user.entries.length == 0
                        ? Container(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : createEntryChart(context)
                  ],
                ),
              ),
              CustomCard(
                delay: 500,
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment(-1, 0),
                        child: CustomText(
                          user.entries.length == 0 && user.hasData
                              ? "No data until now."
                              : "Transportation",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          loading: !user.hasData,
                        )),
                    Align(
                        alignment: Alignment(-1, 0),
                        child: user.entries.length == 0 && user.hasData
                            ? Container()
                            : CustomText(
                                "(Last 7 Days)",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(.8)),
                                loading: !user.hasData,
                              )),
                    user.entries.length == 0
                        ? Container(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : createPieList()
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: OutlineButton(
              onPressed: () {
                toggleTips();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.help,
                    color: colorScheme.iconColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Help",
                    style: colorScheme.textStyle,
                  ),
                ],
              ),
            ),
          ),
        )
      ];
    } else {
      return <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
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
                        onPressed: fetchUser,
                        child: Text(
                          "Reload",
                          style: colorScheme.textStyle,
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
                          style: colorScheme.textStyle,
                        ),
                      ),
                    ],
                  ),
                ]))
      ];
    }
  }

  createEntryChart(context) {
    var data = user.entries;

    return Container(
        height: 300,
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: Chart(
            values: data.map((val) => val.score).toList(),
            measure: data
                .map((val) => "${val.date.day}.${val.date.month}.")
                .toList(),
            dates: data.map((val) => val.date).toList(),
            onTap: (val, date) {
              showBottomSheet(context: context, value: val, date: date);
            }));
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
      child: CustomText(
        hasData
            ? "Welcome ${user.user['username'][0].toUpperCase()}${user.user['username'].substring(1)}"
            : "Welcome User",
        style: colorScheme.textStyle.copyWith(fontSize: 25),
        loading: !user.hasData,
      ),
    );
  }

  Future<User> fetchUser({anim = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userID = prefs.getString(Constants.USER_ID_KEY);

    final response = await http.get("${Constants.URL}/users/$userID");

    if (response.statusCode == 200) {
      setState(() {
          user = User.fromJson(json.decode(response.body));
          fetchingError = false;
          hasData = true;
        });
      return User.fromJson(json.decode(response.body));
    } else {
      setState(() {
        hasData = false;
        fetchingError = true;
      });
      throw Exception('Failed to load User data!');
    }
  }

  Future<Entries> getEntriesByDate(date) async {
    final response =
        await http.get("${Constants.URL}/entry/${user.user['email']}/$date");

    if (response.statusCode == 200) {
      return Entries.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  showBottomSheet({context, value, date}) async {
    Entries entries = await getEntriesByDate(date);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${date.day}.${date.month}.${date.year}",
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Score: ",
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      TextSpan(
                          text: value.toString(),
                          style: TextStyle(
                              color: value >= 0 ? Colors.green : Colors.red,
                              fontSize: 20))
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: getEntriesByDate(date),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: entries.entries.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(
                                    "${entries.entries[index].name[0].toUpperCase()}${entries.entries[index].name.substring(1)}"),
                                leading: Icon(
                                  getIcon(entries.entries[index].typeID),
                                  color: Colors.black,
                                ),
                                subtitle:
                                    Text("${entries.entries[index].amount} KM"),
                              ));
                            },
                          ),
                        );
                      }
                      return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator());
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  IconData getIcon(typeId) {
    if (typeId >= 1 && typeId <= 9) {
      return Icons.directions_car;
    } else if (typeId == 10) {
      return Icons.airplanemode_active;
    } else if (typeId == 11) {
      return Icons.train;
    } else if (typeId == 12) {
      return Icons.directions_bus;
    } else if (typeId == 13) {
      return Icons.directions_bike;
    } else if (typeId == 14) {
      return Icons.directions_walk;
    }
  }

  toggleTips() {
    setState(() {
      showTips = !showTips;
    });
  }
}
