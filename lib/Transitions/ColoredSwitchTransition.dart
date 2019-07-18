import 'package:co2_tracker/Painter/TransitionPainter.dart';
import 'package:flutter/material.dart';

class ColoredSwitchTransition extends PageRouteBuilder {
  Widget widget;
  LinearGradient transitionGradient;

  ColoredSwitchTransition({this.widget, this.transitionGradient})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Stack(
                children: <Widget>[
                  IgnorePointer(
                    child: SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(1, 0), end: Offset(0, 0))
                          .animate(CurvedAnimation(
                              curve: Interval(0.0, .5, curve: Curves.easeInOut),
                              parent: animation)),
                      child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: transitionGradient
                          ),
                          child: ClipRect(
                            child: CustomPaint(
                              size: MediaQuery.of(context).size,
                              painter: TransitionPainter(
                                  animation: Tween<double>(begin: -50.0, end: 50.0)
                                      .animate(CurvedAnimation(
                                          curve: Interval(0.0, 1.0,
                                              curve: Curves.easeInOut),
                                          parent: animation))),
                            ),
                          )),
                    ),
                  ),
                  SlideTransition(
                    child: child,
                    position: Tween<Offset>(
                            begin: Offset(1, 0), end: Offset(0, 0))
                        .animate(CurvedAnimation(
                            curve: Interval(.5, 1.0, curve: Curves.easeInOut),
                            parent: animation)),
                  ),
                ],
              );
            },
            transitionDuration: Duration(milliseconds: 1000));
}
