import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoprojectapp/model/users.dart';
import 'package:demoprojectapp/provider/auth_provider.dart';
import 'package:demoprojectapp/views/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/post.dart';
import '../resources/firestore_methods.dart';
import '../utilis/utils.dart';

class EditPostScreen extends StatefulWidget {
  final editdata;
  EditPostScreen({Key? key, required this.editdata}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController editdisController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editdisController.text  = widget.editdata['description'].toString();
    getUserDetails();
  }
  bool isLoading = false;
  @override
  Users? userDetails;

  getUserDetails() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    userDetails = await authProvider.getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
              color: Colors.black,),
            onPressed: (){
              //clearImage,
            }
          ),
          title: const Text(
            'Edit Post ',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              onPressed: () async{
                widget.editdata['description'] = editdisController.text;
                await updateData(
                  widget.editdata['postId'].toString(),
                  userDetails?.nickname??"",
                  userDetails?.photoUrl??"",
                ).whenComplete(() => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  FeedScreen()),
                ));

             },
              icon: Icon(Icons.check,
                color: Colors.black,
                size: 30,),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ).copyWith(right: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        //  userDetails?.photoUrl??""
                        widget.editdata['profImage'].toString(),
                      ),
                    ),
                    SizedBox(width: 7,),
                    Text(
                      // userDetails?.nickname??"",
                      widget.editdata['username'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6,),
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.editdata['postUrl'],
                    ),
                    fit: BoxFit.fill
                  )
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(left: 15,top: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: TextFormField(
                    controller: editdisController,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                        // hintText: "Write a caption...",
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future updateData(String uid, String username, String profImage)async{
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      final docdata = FirebaseFirestore.instance.collection("posts").doc(uid).update({
        'description': editdisController.text
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
}
