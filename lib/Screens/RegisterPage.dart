import 'dart:async';
import 'dart:convert';
import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/CustomComponents/StyledInput.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Dashboard.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  GlobalKey<FormState> _formKey = new GlobalKey();

  bool _autoValidate = false;
  String _email;
  String _password;
  String _username;

  bool loading = false;

  bool loginError = false;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) =>
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 5,
                    child: Row(
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
                                  color: Colors.redAccent
                              ),
                            ),
                          ],
                        ),
                        loading ? Container(margin: EdgeInsets.only(top: 30), alignment: Alignment(0, 0), child: CircularProgressIndicator(backgroundColor: Colors.white,)) : Container()
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
                          "Welcome!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 20,),
                        Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: Column(
                            children: <Widget>[
                              StyledInput(
                                keyboardType: TextInputType.text,
                                labelText: "Username",
                                validator: (value) {
                                  if(value.isEmpty) return "Type in your Username!";
                                  return null;
                                },
                                onSaved: (value) {
                                  _username = value;
                                },
                              ),
                              SizedBox(height: 10),
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
                                  if(value.isEmpty) return "Type in your Password!";
                                  return null;
                                },
                                onSaved: (value) {
                                  print(value);
                                  _password = value;
                                },
                              ),
                            ],
                          ),
                        ),
                        loginError ?
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("Something went wrong! Please try again!", style: TextStyle(color: Colors.red),)
                        )
                            :
                        Container(),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        FloatingActionButton(
                          elevation: 0,
                          backgroundColor: Colors.redAccent,
                          onPressed: handleRegister,
                          child: Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(2),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: Colors.white, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  handleRegister() async {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Map<String, dynamic> body = {
        "username": _username,
        "email": _email,
        "password": _password
      };

      setState(() {loading = true; loginError = false;});
      try {
        var res = await createPost(Constants.URL + "/users/signup", body: body);
        setState(() {loading = false;});

        await saveUserID(res['userId']);

        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(Constants.USER_ID_KEY, id);
  }
}

Future<dynamic> createPost(String url, {Map body}) async {

  Map<String, String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };

  http.Response response = await http.post(url, body: json.encode(body), headers: headers);
  final int statusCode = response.statusCode;
  print('STATUSCODE: $statusCode, body: $body, response: ${response.body}');
  if(statusCode < 200 || statusCode > 400 || json == null) {
    throw new Exception("Error while fetching data");
  }
  return json.decode(response.body);
}
