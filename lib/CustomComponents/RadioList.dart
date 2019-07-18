import 'package:co2_tracker/CustomComponents/RadioItem.dart';
import 'package:flutter/material.dart';

class RadioList extends StatefulWidget {
  final List<RadioModel> radioList;
  TextStyle globalLabelStyle;
  double labelRadioSpacing;
  double listSpacing;
  Function(int) onChanged;
  RadioStyle radioStyle;

  RadioList({
    Key key,
    @required this.radioList,
    @required this.onChanged,
    this.globalLabelStyle = const TextStyle(),
    this.labelRadioSpacing = 10.0,
    this.listSpacing = 10.0,
    this.radioStyle = const RadioStyle()
  }) : super(key: key);

  @override
  _RadioListState createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  int _clickedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _generateRadioList(),
    );
  }

  List<RadioItem> _generateRadioList() {
    if (widget.radioList.length == 0) return <RadioItem>[];

    List<RadioItem> list = widget.radioList.map((item) {
      if (_clickedValue == null && item.defaultClicked) {
        _clickedValue = item.value;
      }

      return RadioItem(
        label: item.label,
        labelStyle:
            item.labelStyle.compareTo(TextStyle()) == RenderComparison.identical
                ? widget.globalLabelStyle
                : item.labelStyle,
        spacing: widget.labelRadioSpacing,
        onPressed: _onChange,
        clicked: _clickedValue == item.value,
        value: item.value,
        radioStyle: widget.radioStyle,
      );
    }).toList();
    return list;
  }

  void _onChange(int val) {
    setState(() {
      _clickedValue = val;
    });
    widget.onChanged(val);
  }
}

class RadioStyle {
  final Color borderColor;
  final Color iconColor;
  final Size boxSize;

  const RadioStyle(
      {this.borderColor = Colors.white,
      this.iconColor = Colors.black,
      this.boxSize = const Size(25.0, 25.0)});
}

class RadioModel {
  final bool defaultClicked;
  String label;
  int value;
  TextStyle labelStyle;

  RadioModel({
    this.defaultClicked = false,
    this.label = "",
    @required this.value,
    this.labelStyle = const TextStyle(),
  });
}
