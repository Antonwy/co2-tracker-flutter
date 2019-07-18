import 'dart:async';
import 'dart:convert';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/CustomComponents/StyledInput.dart';
import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Screens/RegisterPage.dart';
import 'package:co2_tracker/Transitions/ColoredSwitchTransition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Helper/Login.dart';
import '../Helper/User.dart';
import './Dashboard.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = new GlobalKey();

  bool _autoValidate = false;
  String _email;
  String _password;

  bool loading = false;

  bool loginError = false;

  @override
  Widget build(BuildContext context) {
    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);

    return GradientContainer(
        child: Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.transparent,
      body: ListView(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 8,
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 120,
                            height: 60,
                            child: FlareActor(
                              'assets/animations/logo-anim.flr',
                              animation: 'CO2',
                            ),
                          ),
                          Text(
                            "Score.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                      loading
                          ? Container(
                              margin: EdgeInsets.only(top: 30),
                              alignment: Alignment(0, 0),
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ))
                          : Container(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: colorScheme.iconColor),
                      ),
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            StyledInput(
                              withTransition: true,
                              keyboardType: TextInputType.emailAddress,
                              labelText: "Email",
                              validator: (value) {
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value))
                                  return 'Enter Valid Email';
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                _email = value;
                              },
                            ),
                            SizedBox(height: 10),
                            StyledInput(
                              withTransition: true,
                              obscuredText: true,
                              labelText: "Password",
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Type in your Password!";
                                return null;
                              },
                              onSaved: (value) {
                                _password = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      loginError
                          ? Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Wrong credentials! Please try again!",
                                style: TextStyle(color: Colors.red),
                              ))
                          : Container(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Sign in",
                        style: TextStyle(
                            color: colorScheme.iconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      FloatingActionButton(
                        heroTag: "",
                        elevation: 0,
                        backgroundColor: Colors.redAccent,
                        onPressed: handleLogin,
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Don't have an account yet?",
                        style: colorScheme.textStyle,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(2),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: colorScheme.iconColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              ColoredSwitchTransition(
                                  widget: RegisterPage(),
                                  transitionGradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        colorScheme.fromColor,
                                        colorScheme.toColor
                                      ])));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    ));
  }

  handleLogin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Login newLogin = new Login(email: _email, password: _password);
      setState(() {
        loading = true;
        loginError = false;
      });
      try {
        User user = await createPost(Constants.URL + "/users/login",
            body: newLogin.toMap());
        setState(() {
          loading = false;
        });

        await saveUserID(user.user['id']);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } catch (err) {
        print(err);
        setState(() {
          loginError = true;
          loading = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  saveUserID(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.USER_ID_KEY, id);
    } on Exception catch (e) {
      print(e);
    }
  }
}

Future<User> createPost(String url, {Map body}) async {
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  return http
      .post(url, body: json.encode(body), headers: headers)
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return User.fromJson(json.decode(response.body));
  });
}
