import 'dart:io';

import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/Constants.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  File _image;

  @override
  Widget build(BuildContext context) {
    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "PROFILE",
            style: colorScheme.textStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: colorScheme.iconColor),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Hero(
                tag: 'userIcon',
                child: GestureDetector(
                  onTap: handleImageUpload,
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle ,
                          boxShadow: [BoxShadow(color: Colors.black)]),
                      child: ClipRRect(
                        child: _image == null
                            ? Center(
                                child: Icon(
                                Icons.add,
                                size: 40,
                              ))
                            : Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '${widget.user.user['username'][0].toUpperCase()}${widget.user.user['username'].substring(1)}',
              style: TextStyle(color: colorScheme.iconColor, fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: colorScheme.cardColor),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Created at: ",
                        style: textStyle,
                      ),
                      Text(
                        "${widget.user.user['createdAt'].day}.${widget.user.user['createdAt'].month}.${widget.user.user['createdAt'].year}",
                        style: textStyle.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Email: ",
                        style: textStyle,
                      ),
                      Text(
                        "${widget.user.user['email']}",
                        style: textStyle.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Divider(
                    color: Colors.white.withOpacity(.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Reset Password",
                                textAlign: TextAlign.center,
                                style: textStyle.copyWith(fontSize: 15)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Reset Score",
                                textAlign: TextAlign.center,
                                style: textStyle.copyWith(fontSize: 15)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.white.withOpacity(.5),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        handleLogout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Logout",
                            style: textStyle.copyWith(fontSize: 15)),
                      ),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  handleImageUpload() async {
    print('ADD Image');

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  handleLogout(c) async {
    print("LOGOUT");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(Constants.USER_ID_KEY);

    Navigator.push(c, MaterialPageRoute(builder: (c) => RegisterPage()));
  }

  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 17);
}
