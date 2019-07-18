import 'dart:math';

import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

double mapValue(n, start1, stop1, start2, stop2) {
  return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2;
}

Offset getPositionFromKey(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  final pos = renderBox.localToGlobal(Offset.zero);
  return pos;
}

Size getSizeFromKey(GlobalKey key) {
    final RenderBox containerRenderBox =
        key.currentContext.findRenderObject();
    return containerRenderBox.size;
  }

double calcRadius(Size size) {
  return sqrt(pow(size.width, 2) + pow(size.height, 2));
}

double calcEdgeRadius(Size size) {
  return sqrt(pow(size.width / 2, 2) + pow(size.height / 2, 2));
}
