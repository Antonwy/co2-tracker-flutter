import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomText extends StatefulWidget {
  String text;
  TextStyle style;
  bool loading;
  Color backColor;
  Color frontColor;
  bool autoColor;

  CustomText(@required this.text,
      {this.style,
      this.loading = false,
      this.backColor = Colors.grey,
      this.frontColor = Colors.white,
      this.autoColor = true});

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> with TickerProviderStateMixin {
  Size textSize;

  AnimationController _controller;

  AnimationController _switchAnimController;

  ColorSchemeHelper colorScheme;

  Animation<double> _sizeAnim;

  bool _defaultLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _defaultLoading = widget.loading;

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..addListener(() {
            setState(() {});
          })
          ..forward()
          ..repeat();

    _switchAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..addListener(() {
            setState(() {});
          });

    textSize = calculateSize(widget.text, widget.style);
  }

  @override
  Widget build(BuildContext context) {
    _sizeAnim = Tween<double>(begin: textSize.width, end: 0.0).animate(
        CurvedAnimation(
            parent: _switchAnimController,
            curve: Interval(0.0, .6, curve: Curves.easeInOut)));

    if (widget.autoColor) {
      colorScheme = Provider.of<ColorSchemeHelper>(context);
    }

    if (_defaultLoading == widget.loading) {
      
      if (!widget.loading) {
        _switchAnimController.forward();
      }else {
        _switchAnimController.reverse();
      }

      Future.delayed(Duration(milliseconds: (1500 * 0.6).floor()), () {
        setState(() {
          textSize = calculateSize(widget.text, widget.style);
        });
      });

      _defaultLoading = !widget.loading;
    }

    return Container(
        width: textSize.width,
        height: textSize.height,
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(textSize.height / 2),
                clipper: CustomLoadingClipper(
                    innerSize: Size(textSize.width, textSize.height > 15 ? 15 : textSize.height),
                    radius: Radius.circular(textSize.height / 2)),
                child: Container(
                  // color: Colors.red,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      Container(
                        width: _sizeAnim.value,
                        height: textSize.height > 15 ? 15 : textSize.height,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(textSize.height / 2),
                            color: widget.autoColor
                                ? colorScheme.toColor
                                : widget.backColor),
                      ),
                      Positioned(
                        left: Tween<double>(
                                begin: -textSize.width, end: textSize.width)
                            .animate(CurvedAnimation(
                                parent: _controller, curve: Curves.easeInOut))
                            .value,
                        child: Container(
                          width: _sizeAnim.value,
                          height: textSize.height > 15 ? 15 : textSize.height,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: <Color>[
                            widget.frontColor.withAlpha(0),
                            widget.frontColor.withAlpha(20),
                            widget.frontColor.withAlpha(0),
                          ])),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: Tween(begin: -textSize.height, end: 0.0)
                    .animate(CurvedAnimation(
                        parent: _switchAnimController,
                        curve: Interval(.6, 1.0, curve: Curves.easeInOut)))
                    .value,
                child: Opacity(
                  opacity: Tween(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                          parent: _switchAnimController,
                          curve: Interval(.6, 1.0, curve: Curves.easeInOut)))
                      .value,
                  child: Text(
                    widget.text,
                    style: widget.style,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Size calculateSize(String text, TextStyle style) {
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);

    painter.text = TextSpan(text: text, style: style);
    painter.layout();

    return painter.size;
  }
}

class CustomLoadingClipper extends CustomClipper<RRect> {
  Size innerSize;
  Radius radius;

  CustomLoadingClipper({this.innerSize, this.radius});

  @override
  RRect getClip(Size size) {
    // TODO: implement getClip
    return RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(size.width / 2 , size.height / 2),
            width: size.width,
            height: innerSize.height),
        radius);
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
