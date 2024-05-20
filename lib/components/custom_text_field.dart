import 'package:flutter/material.dart';

class EBuddyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool password;
  final TextInputType textInputType;

  const EBuddyTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.password,
    required this.textInputType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EBuddyTextFieldState();
  }
}

class _EBuddyTextFieldState extends State<EBuddyTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.password,
      obscuringCharacter: "*",
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        label: Text(widget.label),
        labelStyle: TextStyle(
          color: Colors.purple,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.purple,
            width: 2,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.purple,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.purple,
            width: 2,
          ),
        ),
      ),
    );
  }
}
