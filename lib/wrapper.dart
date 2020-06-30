import 'package:flutter/material.dart';
import 'package:zine/pages/homePage.dart';
import 'package:zine/pages/signInPage.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWeapperState createState() => _HomeWeapperState();
}

class _HomeWeapperState extends State<HomeWrapper> {
  bool isSignedIn = true;

  @override
  Widget build(BuildContext context) {
    return isSignedIn ? HomePage() : SignInPage();
  }
}
