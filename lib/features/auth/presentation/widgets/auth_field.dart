import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      this.isObscured = false});

  final TextEditingController textEditingController;
  final String hintText;

  final bool isObscured;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: TextFormField(
        controller: textEditingController,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hintText,
        ),
        obscureText: isObscured,
        validator: (value) {
          if (value?.isEmpty ?? false) {
            return '$hintText is missing!';
          }
          return null;
        },
      ),
    );
  }
}
