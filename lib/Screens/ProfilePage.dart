import 'package:co2_tracker/CustomComponents/GradientContainer.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("PROFILE"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Hero(
                tag: 'userIcon',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: Center(
                      child: Text(
                    user.user['username'][0].toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '${user.user['username'][0].toUpperCase()}${user.user['username'].substring(1)}',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color: Colors.white.withOpacity(.13),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Created at: ",
                        style: textStyle,
                      )
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 20);
}
