import 'package:flutter/material.dart';
import 'package:zine/widgets/HeaderWidget.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(
        context,
        strTitle: "Notification",
      ),
    );
  }
}
