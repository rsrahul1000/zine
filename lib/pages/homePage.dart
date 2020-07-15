import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zine/pages/NotificationsPage.dart';
import 'package:zine/pages/ProfilePage.dart';
import 'package:zine/pages/SearchPage.dart';
import 'package:zine/pages/TimeLinePage.dart';
import 'package:zine/pages/UploadPage.dart';
import 'package:zine/widgets/home/home_header.dart';
import 'package:flutter/services.dart';
import 'package:zine/wrapper.dart';

class HomePage extends StatefulWidget {
  // final Function signOutGoogle;
  // HomePage(this.signOutGoogle);

  @override
  _HomePageState createState() => _HomePageState(); //signOutGoogle);
}

class _HomePageState extends State<HomePage> {
  PageController pageController;
  int getPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Function signOutGoogle;
  //_HomePageState(this.signOutGoogle);
  void initState() {
    super.initState();
    pageController = PageController();
  }

  _whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  _onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Color _getActiveColor(int pageIndex) {
    //if (pageIndex > 0) return Colors.black;
    return (pageIndex == 0 || pageIndex == 2) ? Colors.white : Colors.black;
  }

  Color _getBackgroudColorForScafffold(int pageIndex) {
    //if (pageIndex == 0) return Colors.black;
    return (pageIndex == 0 || pageIndex == 2) ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(children: <Widget>[
        PageView(
          children: <Widget>[
            TimeLinePage(gCurrentUser: currentUser),
            SearchPage(),
            UploadPage(gCurrentUser: currentUser),
            NotificationsPage(),
            ProfilePage(userProfileId: currentUser.id),
          ],
          controller: pageController,
          onPageChanged: _whenPageChanges,
          physics: NeverScrollableScrollPhysics(),
        ),
        this.getPageIndex == 0 ? homeHeader() : Container(),
      ]),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: _onTapChangePage,
        backgroundColor: _getBackgroudColorForScafffold(
            getPageIndex), //Colors.transparent, //Theme.of(context).accentColor,
        activeColor: _getActiveColor(getPageIndex), //Colors.white,
        inactiveColor: Colors.grey[400],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 37.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text('Inbox')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
        ],
      ),
    );
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
