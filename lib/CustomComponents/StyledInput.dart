import 'package:co2_tracker/Helper/ColorSchemeHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StyledInput extends StatelessWidget {

  final String labelText;
  final TextInputType keyboardType;
  final Function validator;
  final Function onSaved;
  final bool obscuredText;
  final bool withTransition;

  StyledInput({this.labelText, this.keyboardType, this.validator, this.onSaved, this.obscuredText=false, this.withTransition=false});

  @override
  Widget build(BuildContext context) {

    ColorSchemeHelper colorScheme = Provider.of<ColorSchemeHelper>(context);

    return Material(
      color: Colors.transparent,
      child: TextFormField(
        obscureText: obscuredText,
        style: colorScheme.textStyle,
        cursorColor: colorScheme.iconColor,
        autocorrect: false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintStyle: TextStyle(color: colorScheme.iconColor.withOpacity(.5)),
            labelStyle: TextStyle(color: colorScheme.iconColor.withOpacity(.8)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: colorScheme.iconColor)
            ),
            enabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: colorScheme.iconColor.withOpacity(.5))
            ),
            errorBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.redAccent.withOpacity(.5))
            ),
            focusedErrorBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.redAccent)
            ),
            disabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: colorScheme.iconColor.withOpacity(.2))
            ),

            labelText: labelText,
            hintText: labelText
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
