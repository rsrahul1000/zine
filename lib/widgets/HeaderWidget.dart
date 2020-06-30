import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle=false, String strTitle, disapearedbackButton = false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disapearedbackButton ? false : true,
    title: Text(
      isAppTitle ? "Zine" : strTitle,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "TikTokIcons" : "",
        fontSize: isAppTitle ? 45.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
