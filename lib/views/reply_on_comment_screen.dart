import 'package:demoprojectapp/utilis/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/users.dart';
import '../provider/auth_provider.dart';
import '../resources/firestore_methods.dart';

class ReplyCommentScreen extends StatefulWidget {
  final profile;
  final postId;
  final commentId;
  const ReplyCommentScreen({Key? key, this.profile, this.postId, this.commentId}) : super(key: key);

  @override
  State<ReplyCommentScreen> createState() => _ReplyCommentScreenState();
}

class _ReplyCommentScreenState extends State<ReplyCommentScreen> {
  final TextEditingController replyEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }
  Users? userDetails;

  getUserDetails() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    userDetails = await authProvider.getUserDetails();
  }
  void postCommentrelpy(String uid, String name, String profilePic, String commentId) async {
    try {
      String res = await FireStoreMethods().postCommentreply(
        widget.postId,
        replyEditingController.text,
        uid,
        name,
        profilePic,
        commentId,
      ).whenComplete(() => Navigator.pop(context));

      if (res != 'success') {
        showSnackBar(context, res);

      }
      setState(() {
        replyEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reply"),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    widget.profile??""
                  //userDetails?.photoUrl??"",
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: replyEditingController,
                    decoration: InputDecoration(
                      hintText: 'Reply on Comment',
                      //   'as ${userDetails?.nickname}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                postCommentrelpy(
                  userDetails?.id??"",
                  userDetails?.nickname??"",
                  userDetails?.photoUrl??"",
                  widget.commentId
                ),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Reply',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
