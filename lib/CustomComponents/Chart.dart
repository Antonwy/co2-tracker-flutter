import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final List<int> values;
  final List<String> measure;
  final List<DateTime> dates;
  final double spaceBetween;
  final Function onTap;

  const Chart(
      {Key key,
      @required this.values,
      @required this.measure,
      this.dates,
      this.onTap,
      this.spaceBetween = 5})
      : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  bool animate = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        animate = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          Size size = Size(constraints.maxWidth, constraints.maxHeight);
          return Column(
            children: generateBars(size),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        },
      ),
    );
  }

  List<Widget> generateBars(Size size) {
    List<Widget> posVal = [];
    List<Widget> negVal = [];
    List<Widget> measureVal = [];

    int maxVal =
        getHighestValue(widget.values.map((val) => val.abs()).toList());

    int padding = 40;

    for (int i = 0; i < widget.values.length; i++) {
      int val = widget.values[i];
      String mes = widget.measure[i];
      DateTime date = widget.dates[i];
      double mappedVal = mapValue(val, 0, maxVal, 0, (size.height / 2) - padding);
      if (val >= 0) {
        posVal.add(positiveBar(
            size: size,
            height: mappedVal,
            value: val,
            measure: mes,
            date: date));
        negVal.add(Container(
          width: (size.width / widget.values.length) - widget.spaceBetween / 2,
          height: 0,
        ));
      } else {
        negVal.add(negativeBar(
            size: size,
            height: mappedVal,
            value: val,
            measure: mes,
            date: date));
        posVal.add(Container(
          width: (size.width / widget.values.length) - widget.spaceBetween / 2,
          height: 0,
        ));
      }

      measureVal.add(measureText(size: size, value: mes));
    }
    return <Widget>[
      Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: posVal,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Divider(
              color: Colors.white,
              height: 0,
            ),
            Row(
              children: negVal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ],
        ),
      ),
      Row(
        children: measureVal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      )
    ];
  }

  Widget negativeBar({size: Size, height, value, measure, date}) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            widget.onTap(value, date);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width:
                (size.width / widget.values.length) - widget.spaceBetween / 2,
            height: animate ? 0 : -height ,
            decoration: BoxDecoration(
              color: hexToColor("#FF1AB9"),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
            ),
          ),
        ),
        Container(
          height: 20,
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            style: valText,
          ),
        )
      ],
    );
  }

  Widget positiveBar({size: Size, height, value, measure, date}) {
    return Column(
      children: <Widget>[
        Container(
          height: 20,
          child: Text(
            value.toString(),
            style: valText,
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.onTap(value, date);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width:
                (size.width / widget.values.length) - widget.spaceBetween / 2,
            height: animate ? 0 : height,
            decoration: BoxDecoration(
              color: hexToColor("#80FDD7"),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget measureText({size: Size, value}) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10),
      width: (size.width / widget.values.length) - widget.spaceBetween / 2,
      child: Text(
        value,
        style: mesText,
        textAlign: TextAlign.center,
      ),
    );
  }

  int getLowestValue(List<int> list) {
    return list.reduce((curr, next) => curr < next ? curr : next);
  }

  int getHighestValue(List<int> list) {
    return list.reduce((curr, next) => curr > next ? curr : next);
  }

  TextStyle valText = TextStyle(color: Colors.white, fontSize: 10);

  TextStyle mesText = TextStyle(
    color: Colors.white,
    fontSize: 12,
  );
}
