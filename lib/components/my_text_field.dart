import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        fillColor: Colors.grey.shade200,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
