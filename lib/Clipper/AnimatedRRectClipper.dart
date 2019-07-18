import 'package:flutter/material.dart';


class AnimatedRRectClipper extends CustomClipper<RRect> {

  Size startSize;
  Size endSize;
  Offset pos;
  double borderRadius;
  Animation<double> animation;
  CurvedAnimation curvedAnimation;

  AnimatedRRectClipper({this.startSize, this.borderRadius = 0.0, this.animation, this.pos = const Offset(0,0), this.endSize});

  @override
  RRect getClip(Size size) {
    // TODO: implement getClip

    curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);

    return RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Tween<Offset>(begin: Offset(pos.dx + startSize.width / 2, pos.dy + startSize.height / 2), end: Offset(endSize.width / 2, endSize.height / 2)).animate(curvedAnimation).value,
        width: Tween<double>(begin: startSize.width, end: endSize.width).animate(curvedAnimation).value,
        height: Tween<double>(begin: startSize.height, end: endSize.height).animate(curvedAnimation).value
      ),
      Radius.circular(Tween<double>(begin: borderRadius, end: 0.0).animate(curvedAnimation).value)
    );
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}