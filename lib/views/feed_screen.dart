import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoprojectapp/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import 'login_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();

    if(authProvider.getUserFirebaseId()?.isNotEmpty == true){
      currentUserId = authProvider.getUserFirebaseId()!;
    }else{
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> LoginScreen()),
              (Route<dynamic> route) => false);
    }
    // listScrollConttroller.addListener(scrollListener);
  }
  late final FirebaseFirestore firestore;

  late AuthProvider authProvider;
  late String currentUserId;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //function for signout method
  Future<void> handleSignOut() async{
    authProvider.handleSignOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text("Instagram",
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: (){
                handleSignOut();
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 0.3 ,
                  vertical: 10 ,
                ),
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
