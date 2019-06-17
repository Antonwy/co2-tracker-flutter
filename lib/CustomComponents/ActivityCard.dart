import 'package:flutter/material.dart';

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

class _ActivityCardState extends State<ActivityCard> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    clicked = widget.clickedID == widget.id ? true : false;
    return GestureDetector(
      onTap: () {
        widget.onPressed(
            {"id": widget.id, "name": widget.name, "icon": widget.icon});
        setState(() {
          clicked = !clicked;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: clicked
                ? Colors.white.withOpacity(.8)
                : Colors.white.withOpacity(.13),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: clicked ? Colors.black26 : Colors.transparent,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: new Offset(1.0, 0.0),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: widget.name,
              child: Icon(widget.icon,
                  color: clicked ? Colors.black : Colors.white, size: 50),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.name,
              style: TextStyle(
                  color: clicked ? Colors.black : Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}

typedef void GestureTapCallback(Map<String, dynamic> transportation);
