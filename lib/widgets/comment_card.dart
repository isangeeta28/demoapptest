import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoprojectapp/model/users.dart';
import 'package:demoprojectapp/utilis/utils.dart';
import 'package:demoprojectapp/widgets/reply_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../resources/firestore_methods.dart';
import '../views/reply_on_comment_screen.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final postId;
  final uid;
  final image;
  const CommentCard({Key? key, required this.snap, this.postId, this.uid, this.image}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
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
  final TextEditingController replyEditingController = TextEditingController();
  void postCommentrelpy(String uid, String name, String profilePic, String commentId) async {
    try {
      String res = await FireStoreMethods().postCommentreply(
        widget.postId,
        replyEditingController.text,
        uid,
        name,
        profilePic,
        commentId,
      );

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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.snap.data()['profilePic'].toString(),
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.snap.data()['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                            ),
                            TextSpan(
                              text: ' ${widget.snap.data()['text']}',
                              style: TextStyle(color: Colors.black)
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Text(
                              DateFormat.yMMMd().format(
                                widget.snap.data()['datePublished'].toDate()!,
                              ),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400,),
                            ),
                            SizedBox(width: 20,),
                            widget.snap.data()['uid'] == widget.uid
                            ?Text("Reply",
                              style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500,),)
                                :
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ReplyCommentScreen(
                                    profile: widget.image??"",
                                    //profile: widget.snap.data()['profilePic'].toString(),
                                    commentId: widget.snap.data()['commentId'],
                                    postId: widget.postId
                                )));

                              },
                              child: Text("Reply",
                                style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500,),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   child: const Icon(
              //     Icons.favorite,
              //     size: 16,
              //   ),
              // )
            ],
          ),
          Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .doc(widget.snap.data()['commentId'],)
                  .collection("reply").orderBy("datePublished",descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => ReplyCard(
                    snap: snapshot.data!.docs[index],
                    //postId: widget.postId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
