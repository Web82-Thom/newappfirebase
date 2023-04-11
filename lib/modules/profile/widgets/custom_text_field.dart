import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final void Function(String)? onChanged;
  final bool isObscure;
  final TextInputType? textInputType;
  final int? maxLines;
  final TextInputAction? textInputAction;
  const CustomTextField({Key? key, this.controller, required this.labelText, required this.isObscure, this.onChanged, this.textInputType, this.maxLines, this.hintText, this.textInputAction}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  final Color _underlineColor = const Color(0xFFCCCCCC);
  final Color _mainColor = const Color(0xFF07ac12);
  final Color _color1 = const Color(0xFF515151);
  final Color _color2 = const Color(0xff777777);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.textInputType,
      obscureText: widget.isObscure,
      maxLines: widget.maxLines,
      style: TextStyle(color: _color1),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _mainColor, width: 2.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _underlineColor),

        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: TextStyle(color: _color2),
      ),
    );
  }
}