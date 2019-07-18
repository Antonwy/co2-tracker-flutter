import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:co2_tracker/Helper/User.dart';
import 'package:co2_tracker/Screens/AddActivityPage.dart';
import 'package:co2_tracker/Transitions/CircularRevealTransition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomFabTips extends StatefulWidget {
  final User user;
  final bool showTips;
  final Size size;
  final Function toggle;

  const CustomFabTips({
    Key key,
    this.user,
    this.showTips,
    this.size,
    this.toggle,
  }) : super(key: key);

  @override
  _CustomFabTipsState createState() => _CustomFabTipsState();
}

class _CustomFabTipsState extends State<CustomFabTips>
    with TickerProviderStateMixin {
  
  GlobalKey _fabKey = GlobalKey();

  AnimationController _controller;
  AnimationController _rippleController;
  Animation _rippleAnim;
  Animation _colorAnim;
  Animation _widthAnim;

  AnimationStatus animStatus = AnimationStatus.dismissed;
  bool showText = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            animStatus = status;
            if (status == AnimationStatus.completed && widget.showTips) {
              setState(() {
                showText = true;
              });
            } else if (status == AnimationStatus.reverse) {
              showText = false;
            }
          });

    _rippleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..addListener(() {
            setState(() {});
          });

    _widthAnim = Tween(begin: 0.0, end: widget.size.width)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rippleAnim = Tween(begin: 56.0, end: 200.0).animate(
        CurvedAnimation(parent: _rippleController, curve: Curves.easeInOut));

    _colorAnim = ColorTween(begin: Colors.white, end: Colors.white.withAlpha(0))
        .animate(CurvedAnimation(
            parent: _rippleController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);

    if (widget.showTips && animStatus == AnimationStatus.dismissed) {
      _controller.forward();
      _rippleController.repeat();
    } else if (!widget.showTips && animStatus == AnimationStatus.completed) {
      _controller.reverse();
      _rippleController.reverse(from: _rippleAnim.value);
    }

    return Stack(
      children: <Widget>[
        widget.showTips
            ? GestureDetector(
                onTap: widget.showTips
                    ? () {
                        widget.toggle();
                      }
                    : () {},
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: double.infinity,
                  height: double.infinity,
                  color: widget.showTips
                      ? Colors.black.withOpacity(.5)
                      : Colors.transparent,
                ))
            : Container(),
        Positioned(
          right: 15 - (_widthAnim.value - 28),
          bottom: 15 - (_widthAnim.value - 28),
          child: Container(
            width: _widthAnim.value * 2,
            height: _widthAnim.value * 2,
            decoration: BoxDecoration(
                color: colorScheme.toColor,
                borderRadius: BorderRadius.circular(widget.size.width)),
          ),
        ),
        Positioned(
          right: 15.0 - (_rippleAnim.value / 2 - 28),
          bottom: 15.0 - (_rippleAnim.value / 2 - 28),
          child: Container(
            width: _rippleAnim.value,
            height: _rippleAnim.value,
            decoration: BoxDecoration(
                color: _colorAnim.value,
                borderRadius: BorderRadius.circular(_rippleAnim.value / 2)),
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            key: _fabKey,
            onPressed: () {
              Navigator.push(
                  context,
                  CircularRevealTransition(
                      widget: AddActivityPage(user: widget.user),
                      pos: getPositionFromKey(_fabKey),
                      color: Colors.white,
                      startSize: 56.0,
                      withClipper: true,
                      ));
            },
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            tooltip: "Add Activity",
          ),
        ),
        Positioned(
          bottom: widget.size.width / 2.8,
          left: widget.size.width / 4,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 250),
            opacity: showText ? 1 : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Add Activity",
                    style: colorScheme.textStyle.copyWith(fontSize: 25)),
                SizedBox(
                  height: 8,
                ),
                Text(
                    "Click the button to add \na new Activity to your \nCO2-History.",
                    style: TextStyle(
                      color: colorScheme.iconColor.withOpacity(.8),
                      fontSize: 14,
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

}
