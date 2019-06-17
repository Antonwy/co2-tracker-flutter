import 'package:flutter/material.dart';


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
    return Hero(
      tag: labelText,
      child: Material(
        color: Colors.transparent,
        child: TextFormField(
          obscureText: obscuredText,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autocorrect: false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
              labelStyle: TextStyle(color: Colors.white.withOpacity(.8)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(color: Colors.white)
              ),
              enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(color: Colors.white.withOpacity(.5))
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
                  borderSide: BorderSide(color: Colors.white.withOpacity(.2))
              ),

              labelText: labelText,
              hintText: labelText
          ),
          validator: validator,
          onSaved: onSaved,
        ),
      ),
    );
  }
}
