import 'package:co2_tracker/Clipper/CircularClipper.dart';
import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';

class CircularRevealTransition extends PageRouteBuilder {
  final Widget widget;
  final Offset pos;
  final Color color;
  final double startSize;
  final bool withClipper;
  final Duration duration;

  CircularRevealTransition( 
      {
      this.startSize = 0.0,
      @required this.widget,
      this.pos = const Offset(0,0),
      this.color = Colors.white,
      this.withClipper = true,
      this.duration = const Duration(milliseconds: 500)
      })
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              // return new FadeTransition(
              //   opacity: Tween<double>(
              //     begin: 0.0, end: 1.0
              //   ).animate(animation),
              //   child: SlideTransition(
              //     position: Tween<Offset>(begin: Offset(0.0, .1), end: Offset.zero).animate(animation),
              //     child: ScaleTransition(
              //       scale: Tween<double>(begin: .8, end: 1.0).animate(animation),
              //       child: child)),
              //   // child: child,
              // );

              Animation anim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut
              ));

              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (withClipper) {
                    return ClipRRect(
                      key: UniqueKey(),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          child,
                          IgnorePointer(
                            child: Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              color: ColorTween(
                                      begin: color, end: color.withAlpha(0))
                                  .animate(animation)
                                  .value,
                            ),
                          ),
                        ],
                      ),
                      clipper: CircularClipper(
                          anim: anim,
                          pos: pos,
                          startSize: startSize),
                      clipBehavior: Clip.antiAlias,
                    );
                  } else {
                    print('${constraints.maxWidth}, ${constraints.maxHeight}');
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: IgnorePointer(
                            child: Container(
                              width: calcRadius(Size(constraints.maxWidth, constraints.maxHeight)) * anim.value,
                              height: constraints.maxHeight * anim.value,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                            ),
                          ),
                        ),
                        FadeTransition(
                          opacity: anim,
                          child: child,
                        ),
                      ],
                    );
                  }
                },
              );
            },
            transitionDuration: duration);
}
