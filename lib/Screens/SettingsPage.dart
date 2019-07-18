import 'package:co2_tracker/CustomComponents/CustomAppBar.dart';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "SETTINGS",
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Colorscheme:",
                  style: colorScheme.textStyle.copyWith(fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      OutlineButton(
                        onPressed: () {
                          colorScheme.setColorScheme(Scheme.purple);
                          setColorTheme(0);
                        },
                        child: Text(
                          "Purple",
                          style: colorScheme.textStyle,
                        ),
                      ),
                      OutlineButton(
                        onPressed: () {
                          colorScheme.setColorScheme(Scheme.white);
                          setColorTheme(1);
                        },
                        child: Text(
                          "White",
                          style: colorScheme.textStyle,
                        ),
                      ),
                      OutlineButton(
                        onPressed: () {
                          colorScheme.setColorScheme(Scheme.black);
                          setColorTheme(2);
                        },
                        child: Text(
                          "Black",
                          style: colorScheme.textStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () {
                      colorScheme.setColorScheme(Scheme.yellow);
                      setColorTheme(3);
                    },
                    child: Text(
                      "Yellow",
                      style: colorScheme.textStyle,
                    ),
                  ),
                  OutlineButton(
                    onPressed: () {
                      colorScheme.setColorScheme(Scheme.blue);
                      setColorTheme(4);
                    },
                    child: Text(
                      "Blue",
                      style: colorScheme.textStyle,
                    ),
                  ),
                  OutlineButton(
                    onPressed: () {
                      colorScheme.setColorScheme(Scheme.green);
                      setColorTheme(5);
                    },
                    child: Text(
                      "Green",
                      style: colorScheme.textStyle,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () {
                      colorScheme.setColorScheme(Scheme.red);
                      setColorTheme(6);
                    },
                    child: Text(
                      "Red",
                      style: colorScheme.textStyle,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  setColorTheme(int colorID) async {
    /*
    0 = purple,
    1 = white,
    2 = black
    */

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt(Constants.COLOR_ID_KEY, colorID);
  }
}
