import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final int delay;

  const CustomCard({Key key, this.child, this.delay = 0}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    Future.delayed(Duration(milliseconds: widget.delay), () {
    _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
          CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0, curve: Curves.easeInOut))),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0, curve: Curves.easeInOut))),
        child: Card(
          color: colorScheme.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child:
              Padding(padding: const EdgeInsets.all(15.0), child: widget.child),
        ),
      ),
    );
  }
}
