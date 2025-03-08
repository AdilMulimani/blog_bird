import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton(
      {super.key, required this.onPressed, required this.buttonText});

  final VoidCallback onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppPalette.gradient1,
                  AppPalette.gradient2,
                  // AppPalette.gradient3
                ])),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              fixedSize: const Size(400, 60),
              shadowColor: AppPalette.transparentColor,
              backgroundColor: AppPalette.transparentColor),
          child: Text(
            buttonText,
            style: const TextStyle(
                color: AppPalette.whiteColor,
                fontWeight: FontWeight.w400,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}
