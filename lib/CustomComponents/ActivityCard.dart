import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final int id;
  final Function onPressed;
  final int clickedID;

  ActivityCard(
      {Key key,
      @required this.icon,
      @required this.onPressed,
      @required this.id,
      this.name,
      this.clickedID})
      : super(key: key);

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard>
    with SingleTickerProviderStateMixin {
  bool clicked = false;

  AnimationController _controller;
  Animation<double> _animatedCircle;
  Animation<Color> _colorTween;

  Offset _clickPos = Offset(0, 0);

  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animatedCircle = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
          ..addListener(() {
            setState(() {});
          });
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.clickedID == widget.id) _controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);

    clicked = widget.clickedID == widget.id ? true : false;

    if (_controller != null && !clicked) {
      _controller.reverse();
    }

    return LayoutBuilder(builder: (context, constraints) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTapDown: (TapDownDetails details) => onTapDown(context, details),
          onTap: () {
            widget.onPressed(
                {"id": widget.id, "name": widget.name, "icon": widget.icon}, _key);
            setState(() {
              clicked = !clicked;
            });
            _controller.forward();
          },
          child: Container(
            key: _key,
            decoration: BoxDecoration(
              color: colorScheme.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              Positioned(
                left: _clickPos.dx - MediaQuery.of(context).size.width * _animatedCircle.value,
                top: _clickPos.dy - MediaQuery.of(context).size.height * _animatedCircle.value,
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 * _animatedCircle.value,
                  height: MediaQuery.of(context).size.height * 2 * _animatedCircle.value,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                  )
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: widget.name,
                    child:
                        Icon(widget.icon, color: _colorTween.value, size: 50),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(color: _colorTween.value, fontSize: 18),
                  )
                ],
              ),
            ]),
          ),
        ),
      );
    });
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox box = context.findRenderObject();
    _clickPos = box.globalToLocal(details.globalPosition);
  }
}
