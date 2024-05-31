import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:flutter/material.dart';

class AccessNav extends StatefulWidget {
  const AccessNav({super.key});

  @override
  State<AccessNav> createState() => _AccessNavState();
}

class _AccessNavState extends State<AccessNav> {
  bool isSignIn = true;
  void changeState() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isSignIn? LoginPage(function: changeState) : SignUp(function: changeState);
  }
}