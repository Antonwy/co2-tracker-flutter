import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/ProfilePage.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final User user;
  final bool backButton;

  CustomAppBar({Key key, this.title, this.user, this.backButton = true})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: backButton,
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Align(
            child: 
            user == null ? Container() :
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => ProfilePage(user: user,)));
              },
              child: Hero(
                tag: "userIcon",
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(child: Text(user.user['username'][0].toUpperCase())),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
