import 'package:co2_tracker/Clipper/AnimatedRRectClipper.dart';
import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';

class AddActivityTransition extends PageRouteBuilder {
  Widget widget;
  double borderRadius;
  GlobalKey startWidgetKey;
  Duration duration;

  AddActivityTransition(
      {@required this.widget, this.borderRadius = 10.0, this.startWidgetKey, this.duration = const Duration(milliseconds: 500)})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return ClipRRect(
                child: Stack(
                  children: <Widget>[
                    child,
                    IgnorePointer(
                        child: Container(
                      color: ColorTween(
                              begin: Colors.white,
                              end: Colors.white.withAlpha(0))
                          .animate(CurvedAnimation(
                              parent: animation, curve: Curves.easeInOut))
                          .value,
                    ))
                  ],
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                clipper: AnimatedRRectClipper(
                    animation: animation,
                    startSize: getSizeFromKey(startWidgetKey),
                    endSize: MediaQuery.of(context).size,
                    pos: getPositionFromKey(startWidgetKey),
                    borderRadius: 10.0),
              );
            },
            transitionDuration: duration);
}
