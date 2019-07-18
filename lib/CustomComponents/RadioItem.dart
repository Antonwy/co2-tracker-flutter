import 'package:co2_tracker/CustomComponents/RadioList.dart';
import 'package:flutter/material.dart';
import '../Painter/SplashPainter.dart';

class RadioItem extends StatefulWidget {
  String label;
  bool clicked;
  double spacing;
  TextStyle labelStyle;
  EdgeInsets padding;
  Function(int) onPressed;
  int value;
  RadioStyle radioStyle;


  RadioItem(
      {Key key,
      @required this.onPressed,
      this.label = "",
      this.clicked = false,
      this.spacing = 10.0,
      this.labelStyle = const TextStyle(),
      this.value = 0,
      this.padding = const EdgeInsets.all(5.0),
      this.radioStyle = const RadioStyle()})
      : super(key: key);

  _RadioItemState createState() => _RadioItemState();
}

class _RadioItemState extends State<RadioItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _splashAnim;
  Animation<double> _scaleAnim;
  Animation<double> _opacityAnim;

  bool _shouldAnimate = true;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {});
          });

    _splashAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, .6, curve: Curves.easeInOut)));

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(.6, 1.0, curve: Curves.easeInOut)));

    _opacityAnim = Tween<double>(begin: .7, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldAnimate == widget.clicked) {
      if (_shouldAnimate == true) {
        _controller.forward();
      } else {
        _controller.reverse();
      }

      _shouldAnimate = !_shouldAnimate;
    }

    return GestureDetector(
      onTap: () {
        widget.onPressed(widget.value);
      },
      child: Container(
        padding: widget.padding,
        child: Row(children: <Widget>[
          ClipRect(
            child: Opacity(
              opacity: _opacityAnim.value,
                          child: Container(
                width: widget.radioStyle.boxSize.width,
                height: widget.radioStyle.boxSize.width,
                decoration: BoxDecoration(
                  border: Border.all(color: widget.radioStyle.borderColor),
                ),
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  CustomPaint(
                    painter: SplashPainter(splashAnimation: _splashAnim, splashColor: widget.radioStyle.borderColor),
                  ),
                  Center(
                      child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Icon(
                      Icons.done,
                      color: widget.radioStyle.iconColor,
                      size: widget.radioStyle.boxSize.width - 5,
                    ),
                  )),
                ]),
              ),
            ),
          ),
          SizedBox(
            width: widget.spacing,
          ),
          Opacity(
            opacity: _opacityAnim.value,
            child: Text(
              widget.label,
              style: widget.labelStyle,
            ),
          ),
        ]),
      ),
    );
  }
}
