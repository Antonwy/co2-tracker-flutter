import 'package:co2_tracker/Helper/HelperMethods.dart';
import 'package:flutter/material.dart';

class ColorSchemeHelper extends ChangeNotifier {
  Color fromColor = hexToColor("#770CC5");
  Color toColor = hexToColor("#391BBE");
  TextStyle textStyle = TextStyle(color: Colors.white);
  Color iconColor = Colors.white;
  Color cardColor = hexToColor("#6034C4");
  MaterialColor primaryColor = Colors.red;

  setFromColor(Color color) {
    fromColor = color;
  }

  setToColor(Color color) {
    toColor = color;
  }

  setTextStyle(TextStyle textStyle) {
    this.textStyle = textStyle;
  }

  setIconColor(Color color) {
    this.iconColor = color;
  }

  setCardColor(Color color) {
    this.cardColor = color;
  }

  setPrimaryColor(Color color) {
    this.primaryColor = color;
  }

  setLightMode() {
    this.setTextStyle(TextStyle(color: Colors.black));
    this.setIconColor(Colors.black);
  }

  setDarkMode() {
    this.setTextStyle(TextStyle(color: Colors.white));
    this.setIconColor(Colors.white);
  }

  setColorScheme(Scheme scheme) {
    switch (scheme) {
      case Scheme.purple:
        this.setFromColor(hexToColor("#770CC5"));
        this.setToColor(hexToColor("#391BBE"));
        this.setCardColor(hexToColor("#6034C4"));
        this.setDarkMode();
        this.setPrimaryColor(Colors.deepPurple);
        break;
      case Scheme.white:
        this.setFromColor(hexToColor("#ffffff"));
        this.setToColor(hexToColor("#E0E0E0"));
        this.setCardColor(hexToColor("#343434"));
        this.setLightMode();
        this.setPrimaryColor(Colors.grey);
        break;
      case Scheme.black:
        this.setFromColor(hexToColor("#2C2828"));
        this.setToColor(hexToColor("#262626"));
        this.setCardColor(hexToColor("#3B3B3B"));
        this.setDarkMode();
        this.setPrimaryColor(Colors.red);
        break;
      case Scheme.yellow:
        this.setFromColor(hexToColor("#EDDE89"));
        this.setToColor(hexToColor("#FCEB8E"));
        this.setCardColor(hexToColor("#343434"));
        this.setLightMode();
        this.setPrimaryColor(Colors.red);
        break;
      case Scheme.blue:
        this.setFromColor(hexToColor("#65A7F4"));
        this.setToColor(hexToColor("#359DD5"));
        this.setCardColor(hexToColor("#5CA9DF"));
        this.setDarkMode();
        this.setPrimaryColor(Colors.yellow);
        break;
      case Scheme.green:
        this.setFromColor(hexToColor("#78937A"));
        this.setToColor(hexToColor("#76AD88"));
        this.setCardColor(hexToColor("#86AC90"));
        this.setDarkMode();
        this.setPrimaryColor(Colors.blueGrey);
        break;
      case Scheme.red:
        this.setFromColor(hexToColor("#BA5042"));
        this.setToColor(hexToColor("#BA6D6D"));
        this.setCardColor(hexToColor("#BF7570"));
        this.setDarkMode();
        this.setPrimaryColor(Colors.blueGrey);
        break;
      default:
    }
    notifyListeners();
  }
}

enum Scheme { purple, black, white, yellow, blue, red, green }
