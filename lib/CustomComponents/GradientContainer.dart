import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {

  final Widget child;

  GradientContainer({@required this.child});


  @override
  Widget build(BuildContext context) {
    return (
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      hexToColor("#770CC5"),
                      hexToColor("#391BBE")
                    ]
                )
            ),
            child: child
        )
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

}
