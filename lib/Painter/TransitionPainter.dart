import 'package:flutter/material.dart';
import 'dart:math';

class TransitionPainter extends CustomPainter {

  Paint _paint = Paint()
  ..color = Colors.white;
  Animation<double> animation;

  TransitionPainter({@required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    double centerY = size.height / 2.0;


    _paint.strokeWidth = 10.0;
    _paint.style = PaintingStyle.stroke;

    Path path = Path()
    ..moveTo(0, centerY)
    ..quadraticBezierTo(size.width * .25, centerY - animation.value, size.width * .5, centerY)
    ..quadraticBezierTo(size.width * .75, centerY + animation.value, size.width, centerY);

    canvas.drawPath(path, _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

  double hypot(double x, double y) {
    
  return sqrt(x * x + y * y);
  }

}