import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zine/animations/spinner_animation.dart';
import 'package:zine/models/user.dart';
import 'package:zine/pages/CommentsPage.dart';
import 'package:zine/pages/ProfilePage.dart';
import 'package:zine/resources/assets.dart';
import 'package:zine/widgets/ProgressWidget.dart';
import 'package:zine/widgets/home/audio_spinner_icon.dart';
import 'package:zine/widgets/home/controls/video_control_action.dart';
import 'package:zine/wrapper.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  //final String timestamp;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;

  Post({
    this.postId,
    this.ownerId,
    //this.timestamp,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      likes: documentSnapshot["likes"],
      username: documentSnapshot["username"],
      description: documentSnapshot["description"],
      location: documentSnapshot["location"],
      url: documentSnapshot["url"],
    );
  }

  int getTotalNumberOfLikes(likes) {
    if (likes == null) return 0;

    //get total number of likes
    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) counter = counter + 1;
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        likes: this.likes,
        username: this.username,
        description: this.description,
        location: this.location,
        url: this.url,
        likeCount: getTotalNumberOfLikes(likes),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  Map likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
  final String currentOnlineUserId = currentUser?.id;

  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.likeCount,
  });

  _controlUserLikePost() {
    bool _liked = likes[currentOnlineUserId] == true;
    //if post is already liked then do this
    if (_liked) {
      postReference
          .document(ownerId)
          .collection("userPosts")
          .document(postId)
          .updateData({"likes.$currentOnlineUserId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    }
    // if post is not already liked then add like to firestore
    else if (!_liked) {
      postReference
          .document(ownerId)
          .collection("userPosts")
          .document(postId)
          .updateData({"likes.$currentOnlineUserId": true});
      addLike();
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentOnlineUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  removeLike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedReference
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  addLike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;

    if (isNotPostOwner) {
      activityFeedReference
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .setData({
        "type": "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        "timestamp": DateTime.now(),
        "url": url,
        "postId": postId,
        "userProfileImage": currentUser.url,
      });
    }
  }

  _createPostContent() {
    return GestureDetector(
      onDoubleTap: () => _controlUserLikePost(), //() => print("Post Liked"),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.network(
              url,
              fit: BoxFit.fill,
            ),
            showHeart
                ? Icon(Icons.favorite, size: 140.0, color: Colors.pink)
                : Text(""),
          ],
        ),
      ),
    );
  }

  Widget _onScreenControls() {
    return Container(
      //color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(flex: 5, child: _postDesc()),
          Expanded(
            flex: 1,
            child: Container(
              //color: Colors.blue,
              padding: EdgeInsets.only(bottom: 60, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //user profile button
                  userProfile(),
                  //like button
                  GestureDetector(
                    onTap: () => _controlUserLikePost(), //print("Liked post"),
                    child: videoControlAction(
                        icon: AppIcons.heart,
                        label: "$likeCount",
                        iconColor: isLiked ? Colors.pink : Colors.white),
                  ),
                  //comment button
                  GestureDetector(
                    onTap: () => _displayCommentsPanel(context,
                        postId: postId, ownerId: ownerId, url: url),
                    child: videoControlAction(
                        icon: AppIcons.chat_bubble, label: "130"),
                  ),
                  //share button
                  videoControlAction(
                      icon: AppIcons.reply, label: "Share", size: 27),
                  SpinnerAnimation(body: audioSpinner())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _displayCommentsPanel(BuildContext context,
      {String postId, String ownerId, String url}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // return Container(
          //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          //   child: Text("botttom comments"),
          // );
          return CommentsPage(
              postId: postId, postOwnerId: ownerId, postImageurl: url);
        });
  }

  Widget _postDesc() {
    return Container(
      padding: EdgeInsets.only(left: 16, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 7, bottom: 7),
            child: Text(
              "@$username",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 7),
            child: Text(description,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300)),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.music_note,
                size: 19,
                color: Colors.white,
              ),
              Text(
                "location: $location",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget userProfile() {
    return FutureBuilder(
        future: userReference.document(ownerId).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) return circularProgress();

          User user = User.fromDocument(dataSnapshot.data);
          bool isPostOwner = currentOnlineUserId == ownerId;

          return Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: GestureDetector(
                        onTap: () => _displayUserProfile(context, userProfileId: user.id),
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(user.url),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid),
                          color: Colors.black,
                          shape: BoxShape.circle),
                    ),
                    // follow button
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      height: 18,
                      width: 18,
                      child: Icon(Icons.add, size: 10, color: Colors.white),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 42, 84, 1),
                          shape: BoxShape.circle),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  _displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(userProfileId: userProfileId)));
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentOnlineUserId] == true);

    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          _createPostContent(),
          _onScreenControls(),
        ],
      ),
    );
  }
}
