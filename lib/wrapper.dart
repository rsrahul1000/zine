import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zine/pages/SignInPage.dart';
import 'package:zine/pages/homePage.dart';
import 'package:zine/pages/SearchPage.dart';
import 'package:zine/services/auth.dart';

// final GoogleSignIn gSignIn = GoogleSignIn();

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWeapperState createState() => _HomeWeapperState();
}

class _HomeWeapperState extends State<HomeWrapper> {
  bool isSignedIn = false;
  GoogleSignInAccount _currentUser;
  // @override
  // void initState() {
  //   super.initState();
  //   googleSignIn.onCurrentUserChanged.listen((gSignInAccount) {
  //     setState(() {
  //       _currentUser = gSignInAccount;
  //     });
  //     if (_currentUser != null) {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => HomePage()));
  //     } else {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => SignInPage()));
  //     }
  //   }, onError: (gError) {
  //     print("Error Message: " + gError);
  //   });
  // }

  void initState() {
    super.initState();

    googleSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Message: " + gError.toString());
    });

    googleSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      print("Error Message: " + gError.toString());
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      //then create a user
      setState(() {
        print("isSignedIn set to true");
        isSignedIn = true;
      });
    } else {
      setState(() {
        print("isSignedIn set to false");
        isSignedIn = false;
      });
    }
  }

  Widget buildHomeScreen() {
    return RaisedButton.icon(
      onPressed: authService.signOutGoogle,
      icon: Icon(Icons.close),
      label: Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isSignedIn ? HomePage() : SignInPage();
  }
}
