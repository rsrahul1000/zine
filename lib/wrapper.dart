import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zine/pages/CreateAccountPage.dart';
import 'package:zine/pages/SignInPage.dart';
import 'package:zine/pages/homePage.dart';
import 'package:zine/pages/SearchPage.dart';
import 'package:zine/services/auth.dart';
import 'models/user.dart';

// final GoogleSignIn gSignIn = GoogleSignIn();

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final userReference = Firestore.instance.collection("user");
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Posts Pictures");
final postReference = Firestore.instance.collection("posts");
final activityFeedReference = Firestore.instance.collection("feed");
final commentsReference = Firestore.instance.collection("comments");
final followersReference = Firestore.instance.collection("followers");
final followingReference = Firestore.instance.collection("following");

final DateTime timestamp = DateTime.now();
User currentUser;

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWeapperState createState() => _HomeWeapperState();
}

class _HomeWeapperState extends State<HomeWrapper> {
  bool isSignedIn = false;
  GoogleSignInAccount _currentUser = null;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  void initState() {
    super.initState();
    authService.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    googleSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
      setState(() {
        authStatus = AuthStatus.NOT_LOGGED_IN;
        isSignedIn = false;
      });
      print("Error Message: " + gError.toString());
    });

    googleSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      setState(() {
        authStatus = AuthStatus.NOT_LOGGED_IN;
        isSignedIn = false;
      });
      print("Error Message for scilent signin: " + gError.toString());
    });
  }

  Future<void> controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      //to save in the database

      await saveUserInfoToFirestore();
      setState(() {
        _currentUser = signInAccount;
        print("isSignedIn set to true");
        authStatus = AuthStatus.LOGGED_IN;
        isSignedIn = true;
      });
    } else {
      setState(() {
        print("isSignedIn set to false");
        authStatus = AuthStatus.NOT_LOGGED_IN;
        isSignedIn = false;
      });
    }
  }

  saveUserInfoToFirestore() async {
    final GoogleSignInAccount gCurrentUser = googleSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await userReference.document(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
      final username = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAccountPage(),
          ));

      userReference.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "",
        "timestamp": timestamp,
      });
      documentSnapshot = await userReference.document(gCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //return _currentUser != null ? HomePage() : SignInPage();
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new SignInPage();
        break;
      case AuthStatus.LOGGED_IN:
        if (_currentUser != null) {
          return new HomePage();
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
