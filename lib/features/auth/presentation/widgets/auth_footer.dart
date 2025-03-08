import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key, required this.isSignUp, required this.onTap});

  final bool isSignUp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: isSignUp
                ? 'Already have an account?\t'
                : 'Don\'t have an account?\t',
            style: const TextStyle(fontSize: 16)),
        TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            text: isSignUp ? 'Sign in!' : 'Sign up!',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppPalette.gradient2)),
      ])),
    );
  }
}
