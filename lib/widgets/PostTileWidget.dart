import 'package:flutter/material.dart';
import 'package:zine/pages/PostScreenPage.dart';
import 'package:zine/widgets/PostWidget.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  _displayFullPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PostScreenPage(postId: post.postId, userId: post.ownerId)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _displayFullPost(context),
      child: Image.network(post.url),
    );
  }
}
