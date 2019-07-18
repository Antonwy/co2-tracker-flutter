import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/ProfilePage.dart';
import 'package:co2_tracker/Transitions/CircularRevealTransition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final User user;
  final bool backButton;
  final bool elevated;

  CustomAppBar(
      {Key key,
      this.title,
      this.user,
      this.backButton = true,
      this.elevated = false})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  GlobalKey _iconKey = GlobalKey();

  AnimationController _controller;
  bool isElevated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Provider.of<ColorSchemeHelper>(context);

    if(widget.elevated != isElevated) {
      widget.elevated ? _controller.forward() : _controller.reverse();
      isElevated = widget.elevated;
    }

    return AppBar(
      title: Text(
        widget.title,
        style: colorScheme.textStyle,
      ),
      backgroundColor: ColorTween(begin: colorScheme.toColor.withAlpha(0), end: colorScheme.toColor).animate(_controller).value,
      elevation: 0.0,
      automaticallyImplyLeading: widget.backButton,
      centerTitle: true,
      iconTheme: IconThemeData(color: colorScheme.iconColor),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Align(
            child: widget.user == null
                ? Container()
                : InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (c) => ProfilePage(
                      //               user: user,
                      //             )));
                      Navigator.push(
                          context,
                          CircularRevealTransition(
                              widget: ProfilePage(
                                user: widget.user,
                              ),
                              pos: getPositionFromKey(_iconKey),
                              startSize: 30.0,
                              color: colorScheme.toColor));
                    },
                    child: Hero(
                      tag: "userIcon",
                      child: Container(
                        key: _iconKey,
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.iconColor),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Center(
                              child: Text(widget.user.user['username'][0]
                                  .toUpperCase())),
                          textStyle: colorScheme.textStyle,
                        ),
                      ),
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
