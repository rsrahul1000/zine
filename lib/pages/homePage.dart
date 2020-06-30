import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zine/pages/NotificationsPage.dart';
import 'package:zine/pages/ProfilePage.dart';
import 'package:zine/pages/SearchPage.dart';
import 'package:zine/pages/TimeLinePage.dart';
import 'package:zine/pages/UploadPage.dart';
import 'package:zine/widgets/home/home_header.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           HomeScreen(),
//           BottomNavigation(),
//           homeHeader(),
//         ],
//       ),
//     );

//   }
// }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController;
  int getPageIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        PageView(
          children: <Widget>[
            TimeLinePage(),
            SearchPage(),
            UploadPage(),
            NotificationsPage(),
            ProfilePage()
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
        backgroundColor: Colors.transparent, //Theme.of(context).accentColor,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 37.0,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
