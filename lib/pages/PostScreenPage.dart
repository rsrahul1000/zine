import 'package:flutter/material.dart';
import 'package:zine/widgets/PostWidget.dart';
import 'package:zine/widgets/ProgressWidget.dart';
import 'package:zine/wrapper.dart';

class PostScreenPage extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreenPage({this.postId, this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postReference
          .document(userId)
          .collection("userPosts")
          .document(postId)
          .get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) return circularProgress();

        Post post = Post.fromDocument(dataSnapshot.data);
        return Material(
          child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return Container(
                  color: Colors.black,
                  // child: Stack(
                  //   children: <Widget>[post],
                  // ),
                  child: post,
                );
              },
              itemCount: 1),
        );
      },
    );
  }
}
