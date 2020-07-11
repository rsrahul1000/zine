import 'package:flutter/material.dart';
import 'package:zine/widgets/home/controls/onscreen_controls.dart';
import 'package:zine/widgets/home/home_video_renderer.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                AppVideoPlayer(),
                onScreenControls()
              ],
            ),
          );
        },
        itemCount: 10);
  }
}
