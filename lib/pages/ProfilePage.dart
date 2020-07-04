import 'package:flutter/material.dart';
import 'package:zine/pages/SignInPage.dart';
import 'package:zine/services/auth.dart';
import 'package:zine/widgets/HeaderWidget.dart';

class ProfilePage extends StatefulWidget {
  // Function signOutGoogle;
  // ProfilePage(this.signOutGoogle);

  @override
  _ProfilePageState createState() => _ProfilePageState(); //signOutGoogle);
}

class _ProfilePageState extends State<ProfilePage> {
  //_ProfilePageState(this.signOutGoogle);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header(
          context,
          strTitle: "Profile",
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () {
              authService.signOutGoogle();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return SignInPage();
                },
              ), ModalRoute.withName('/'));
            },
            //onPressed: logoutUser,
            child: Text("Signout"),
          ),
        )

        //body: RaisedButton.icon(onPressed: , icon: null, label: null),
        );
  }
}
