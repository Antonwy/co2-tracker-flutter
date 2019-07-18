import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradientContainer extends StatefulWidget {
  final Widget child;

  GradientContainer({@required this.child});

  @override
  _GradientContainerState createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> sizeAnim;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 5000))
          ..addListener(() {
            setState(() {});
          });

    sizeAnim = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Provider.of<ColorSchemeHelper>(context);

    final Size size = MediaQuery.of(context).size;

    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [colorScheme.fromColor, colorScheme.toColor])),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: -size.width / 2,
              top: -size.width / 2,
              child: FadeTransition(
                opacity: sizeAnim,
                              child: Container(
                  width: size.width - 40 * sizeAnim.value,
                  height: size.width - 40 * sizeAnim.value,
                  decoration: BoxDecoration(
                      color: colorScheme.iconColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(size.width)),
                ),
              ),
            ),
            Positioned(
              left: -size.width / 2,
              top: -size.width / 2,
              child: Container(
                width: size.width + 40 * sizeAnim.value,
                height: size.width + 40 * sizeAnim.value,
                decoration: BoxDecoration(
                    color: colorScheme.iconColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(size.width + 40)),
              ),
            ),
            Positioned(
              right: -size.width / 2,
              bottom: -size.width / 2,
              child: FadeTransition(
                opacity: sizeAnim,
                              child: Container(
                  width: size.width + 50 * sizeAnim.value,
                  height: size.width + 50 * sizeAnim.value,
                  decoration: BoxDecoration(
                      color: colorScheme.iconColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(size.width + 50)),
                ),
              ),
            ),
            Positioned(
              right: -size.width / 2,
              bottom: -size.width / 2,
              child: Container(
                width: size.width + 90 * sizeAnim.value,
                height: size.width + 90 * sizeAnim.value,
                decoration: BoxDecoration(
                    color: colorScheme.iconColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(size.width + 90)),
              ),
            ),
            widget.child,
          ],
        ));
  }
}
