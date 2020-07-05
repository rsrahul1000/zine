import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = GoogleSignIn();

//   String name;
//   String email;
//   String imageUrl;

//   Future<FirebaseUser> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount googleSignInAccount =
//           await googleSignIn.signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.getCredential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       final AuthResult authResult =
//           await _auth.signInWithCredential(credential);
//       final FirebaseUser user = authResult.user;

//       assert(!user.isAnonymous);
//       assert(await user.getIdToken() != null);

//       final FirebaseUser currentUser = await _auth.currentUser();
//       assert(user.uid == currentUser.uid);

//       return currentUser; //'signInWithGoogle succeeded: $user';
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   void signOutGoogle() async {
//     await googleSignIn.signOut();

//     print("User Sign Out");
//   }

//   loginUser() async {
//     try {
//       googleSignIn.signIn();
//     } catch (error) {
//       print("Login error: " + error.toString());
//     }
//   }

//   void logoutUser() async {
//     //await googleSignIn.disconnect().whenComplete(() async {
//     await _auth.signOut();
//     //});
//     //await googleSignIn.signOut();
//     print("User Sign Out successfully");
//   }
// }

// final AuthService authService = AuthService();

//************************************* */

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<GoogleSignInAccount> signInWithGoogle();

  void signOutGoogle();
}

class AuthServices implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser user;

  Future<String> signIn(String email, String password) async {
    user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.email;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    user = await _firebaseAuth.currentUser();
    return user;
  }

  signOut() async {
    print("signed in user: $user");
    await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<GoogleSignInAccount> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    user = (await _firebaseAuth.signInWithCredential(credential)).user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    return googleSignInAccount; //user; //'signInWithGoogle succeeded: $user';
  }

  @override
  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}

final AuthServices authService =
    AuthServices(); // add this to the bottom outside the class

// /**************************/

// class AuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   FirebaseUser user;

//   Future<void> signInWithGoogle() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> signOutGoogle() => _googleSignIn.disconnect();

// }

// AuthService authService = AuthService();
