import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zine/models/user.dart';
import 'package:zine/widgets/PostWidget.dart';
import 'package:zine/widgets/ProgressWidget.dart';
import 'package:zine/widgets/home/controls/onscreen_controls.dart';
import 'package:zine/widgets/home/home_video_renderer.dart';
import 'package:zine/wrapper.dart';

class TimeLinePage extends StatefulWidget {
  final User gCurrentUser;

  const TimeLinePage({this.gCurrentUser});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> posts;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController = PageController();

  _retrieveTimeline() async {
    // QuerySnapshot querySnapshot = await timelineReference
    //     .document(widget.gCurrentUser.id)
    //     .collection("timelinePosts")
    //     .orderBy("timestamp", descending: true)
    //     .getDocuments();
    // List<Post> allPosts = querySnapshot.documents
    //     .map((document) => Post.fromDocument(document))
    //     .toList();
    // setState(() {
    //   this.posts = allPosts;
    // });

    //temperary code
    //adding user post to timeline
    QuerySnapshot querySnapshot = await postReference
        .document(widget.gCurrentUser.id)
        .collection("userPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    List<Post> allPosts = querySnapshot.documents
        .map((document) => Post.fromDocument(document))
        .toList();

    // For adding user followers post to timeline
    for (String document in followingsList) {
      //print(document);
      querySnapshot = await postReference
          .document(document)
          .collection("userPosts")
          .orderBy("timestamp", descending: true)
          .getDocuments();
      //print(querySnapshot.documents);
      allPosts = allPosts +
          querySnapshot.documents
              .map((document) => Post.fromDocument(document))
              .toList();
    }
    //print(allPosts.length);
    setState(() {
      //countPost = querySnapshot.documents.length;
      this.posts = allPosts..shuffle();
    });
    //_createUserTimeLine();
  }

  _retrieveFollowings() async {
    QuerySnapshot querySnapshot = await followingReference
        .document(currentUser.id)
        .collection("userFollowing")
        .getDocuments();

    setState(() {
      followingsList = querySnapshot.documents
          .map((document) => document.documentID)
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    _retrieveTimeline();
    _retrieveFollowings();
  }

  _createUserTimeLine() {
    if (posts == null) {
      return circularProgress();
    } else {
      // return ListView(
      //   children: posts,
      // );
      //print(posts[0].postId);
      return PageView.builder(
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            //print(posts[position].ownerId);
            return Container(
              color: Colors.black,
              // child: Stack(
              //   children:
              //       posts, //<Widget>[AppVideoPlayer(), onScreenControls()],
              // ),
              child: posts[position],
            );
          },
          itemCount: posts.length ?? 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        child: _createUserTimeLine(),
        onRefresh: () => _retrieveTimeline(),
      ),
    );
  }
}
