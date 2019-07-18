import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';

class CircularClipper extends CustomClipper<RRect> {
  final Animation<double> anim;
  final Offset pos;
  final double startSize;

  CircularClipper({this.startSize, this.pos, this.anim});

  @override
  RRect getClip(Size size) {
    // return RRect.fromRectAndRadius(
    //   Rect.fromCenter(center: Offset(0,0), width: size.width, height: size.height),
    //   Radius.circular(20)
    // );
    double radius = calcRadius(size);
    return RRect.fromRectAndRadius(
        Rect.fromCircle(
            center: Offset(pos.dx + startSize/2, pos.dy + startSize/2),
            radius: radius * anim.value + startSize / 2),
        Radius.circular(radius * anim.value + startSize));
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
