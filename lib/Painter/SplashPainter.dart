import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';

class SplashPainter extends CustomPainter {
  final Animation splashAnimation;
  Color splashColor;

  Paint _paint = Paint();

  Animation<double> splash;

  SplashPainter(
      {@required this.splashAnimation, this.splashColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {

    splash = Tween<double>(begin: 0.0, end: calcEdgeRadius(size)).animate(splashAnimation);

    _paint.color = splashColor;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, splash.value, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
