import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zine/pages/homePage.dart';
import 'package:zine/services/auth.dart';

import '../wrapper.dart';
import 'CreateAccountPage.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading;
  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  _navigationToHomePage() {
    setState(() {
      _isLoading = true;
    });
    authService.signInWithGoogle().then((GoogleSignInAccount user) async {
      print(user.toString());
      if (user != null) {
        setState(() {
          _isLoading = false;
        });
        await saveUserInfoToFirestore(user);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return HomePage(); //isSignedIn ? HomePage(signOutGoogle): SignInPage();
            },
          ),
        );
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    });
  }

  saveUserInfoToFirestore(GoogleSignInAccount gCurrentUser) async {
    //final GoogleSignInAccount gCurrentUser = googleSignIn.currentUser;
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
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _showCircularProgress(),
        Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: Text('Hi',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                        child: Text('There',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                        child: Text('.',
                            style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                            decoration: InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)))),
                        SizedBox(height: 20.0),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: true,
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: InkWell(
                              child: Text('Forgot Password',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      decoration: TextDecoration.underline))),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          height: 40.0,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.green),
                              ),
                              color: Colors.green,
                              elevation: 7.0,
                              // onPressed: () {
                              //   authService.signInWithGoogle().whenComplete(() {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (context) {
                              //           return HomePage(); //isSignedIn ? HomePage(signOutGoogle): SignInPage();
                              //         },
                              //       ),
                              //     );
                              //   });
                              // },
                              onPressed: _navigationToHomePage,
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.black),
                            ),
                            color: Colors.white,
                            elevation: 7.0,
                            onPressed: _navigationToHomePage,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: ImageIcon(
                                      AssetImage('assets/images/google.png')),
                                  // child: CircleAvatar(
                                  //   backgroundColor: Colors.white,
                                  //   backgroundImage: AssetImage(
                                  //       'assets/images/google.png'),
                                  // ),
                                ),
                                Center(
                                  child: Text(
                                    '  LOG IN WITH GOOGLE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: ImageIcon(AssetImage(
                                        'assets/images/facebook.png')),
                                  ),
                                  Center(
                                    child: Text(
                                      ' LOG IN WITH FACEBOOK',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New To Zine ?',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            )),
      ],
    );
  }
}
