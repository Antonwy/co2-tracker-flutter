import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Screens/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/Constants.dart';
import 'Screens/Dashboard.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  Widget _defaultHome = RegisterPage();

  bool _result = await checkIfLoggedIn();

  if (_result) {
    _defaultHome = Dashboard();
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(ChangeNotifierProvider<ColorSchemeHelper>(
      builder: (_) => ColorSchemeHelper(),
      child: MyApp(
        defaultHome: _defaultHome,
      )));
}

Future<bool> checkIfLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // return false;
  return prefs.containsKey(Constants.USER_ID_KEY);
}

class MyApp extends StatefulWidget {
  final Widget defaultHome;

  const MyApp({Key key, this.defaultHome}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool settedColorScheme = false;

  ColorSchemeHelper colorScheme;

  @override
  Widget build(BuildContext context) {
    colorScheme = Provider.of<ColorSchemeHelper>(context);

    if(!settedColorScheme) setColorScheme();

    return MaterialApp(
      title: 'CO2-Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: colorScheme.primaryColor,
          canvasColor: Colors.transparent
        ),
      home: widget.defaultHome,
    );
  }

  setColorScheme() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(Constants.COLOR_ID_KEY)) {
        int colorID = await prefs.get(Constants.COLOR_ID_KEY);
        switch (colorID) {
          case 0:
            colorScheme.setColorScheme(Scheme.purple);
            break;
          case 1:
            colorScheme.setColorScheme(Scheme.white);
            break;
          case 2:
            colorScheme.setColorScheme(Scheme.black);
            break;
          case 3:
            colorScheme.setColorScheme(Scheme.yellow);
            break;
          case 4:
            colorScheme.setColorScheme(Scheme.blue);
            break;
          case 5:
            colorScheme.setColorScheme(Scheme.green);
            break;
          case 6:
            colorScheme.setColorScheme(Scheme.red);
            break;
          default:
        }
      }else {
        await prefs.setInt(Constants.COLOR_ID_KEY, 0);
      }

      settedColorScheme = true;
  }
}
