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
  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      setState(() {
        _currentUser = gSignInAccount;
      });
      if (_currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      }
    }, onError: (gError) {
      print("Error Message: " + gError);
    });
  }

  // controlSignIn(GoogleSignInAccount signInAccount) async {
  //   if (signInAccount != null) {
  //     //then create a user
  //     setState(() {
  //       isSignedIn = true;
  //     });
  //   } else {
  //     setState(() {
  //       isSignedIn = false;
  //     });
  //   }
  // }

  // void initState() {
  //   super.initState();

  //   gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
  //     controlSignIn(gSignInAccount);
  //   }, onError: (gError) {
  //     print("Error Message: " + gError);
  //   });

  //   gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
  //     controlSignIn(gSignInAccount);
  //   }).catchError((gError) {
  //     print("Error Message: " + gError);
  //   });
  // }

  // controlSignIn(GoogleSignInAccount signInAccount) async {
  //   if (signInAccount != null) {
  //     //then create a user
  //     setState(() {
  //       isSignedIn = true;
  //     });
  //   } else {
  //     setState(() {
  //       isSignedIn = false;
  //     });
  //   }
  // }

  // loginUser() async {
  //   try {
  //     await gSignIn.signIn();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // logoutUser() async {
  //   try {
  //     await gSignIn.signOut();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<String> signInWithGoogle() async {
  //   if (!isSignedIn) {
  //     final GoogleSignInAccount googleSignInAccount =
  //         await googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     final AuthResult authResult =
  //         await _auth.signInWithCredential(credential);
  //     final FirebaseUser user = authResult.user;

  //     assert(!user.isAnonymous);
  //     assert(await user.getIdToken() != null);

  //     final FirebaseUser currentUser = await _auth.currentUser();
  //     assert(user.uid == currentUser.uid);

  //     if (user.uid == currentUser.uid) {
  //       setState(() {
  //         isSignedIn = true;
  //       });
  //     }

  //     return 'signInWithGoogle succeeded: $user';
  //   }
  // }

  // Future signOutGoogle() async {
  //   await googleSignIn.signOut();
  //   if (this.mounted) {
  //     setState(() {
  //       isSignedIn = false;
  //     });
  //   }
  //   Navigator.pop(context);
  //   print("User Sign Out");
  // }

  Widget buildHomeScreen() {
    return RaisedButton.icon(
      onPressed: signOutGoogle,
      icon: Icon(Icons.close),
      label: Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentUser != null
        ? HomePage()
        : SignInPage(); //isSignedIn ? HomePage(signOutGoogle) :
  }
}
