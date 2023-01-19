import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoprojectapp/utilis/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/users.dart';
import '../provider/auth_provider.dart';
import '../provider/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  final image;
  final detail;
  final uid;
  const CommentsScreen({Key? key, required this.postId, this.image, this.detail,this.uid}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
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
  final TextEditingController commentEditingController = TextEditingController();
  final TextEditingController replyEditingController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
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
   // final Users? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments').orderBy("datePublished",descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
              uid: widget.uid,
              postId: widget.postId,
              image: widget.detail??""
            ),
          );
        },
      ),
      // text input
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
                  widget.detail??""
                  //widget.image??""
                  //userDetails?.photoUrl??"",
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    //controller: replyEditingController,
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment',
                       //   'as ${userDetails?.nickname}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    postComment(
                  userDetails?.id??"",
                  userDetails?.nickname??"",
                  userDetails?.photoUrl??"",
                ),
                // postCommentrelpy(
                //   userDetails?.id??"",
                //   userDetails?.nickname??"",
                //   userDetails?.photoUrl??"",
                //   userDetails?.id??"",
                // ),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
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
