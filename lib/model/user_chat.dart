
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firestore_constants.dart';

class UserChat{
  final String id;
  final String photoUrl;
  final String nickname;
  //final String email;
  final String username;
  final String bio;
  final List followers;
  final List following;

  UserChat({

    required this.photoUrl,
    required this.nickname,
    required this.id,
    required this.username,
    //required this.email,
    required this.bio,
    required this.followers,
    required this.following
 });

  Map<String, String> toJson(){
    return {
      FirestoreConstants.id:id,
      FirestoreConstants.nickname: nickname,
      FirestoreConstants.photoUrl: photoUrl,
    };
  }

  factory UserChat.fromJson(Map<String, dynamic> json) => UserChat(
    id:json["id"],
    photoUrl: json["photoUrl"],
    nickname: json["nickname"],
    username: json["username"],
    //email: json["email"],
    bio: json["bio"],
    followers: json["followers"],
    following: json["following"],
  );

  factory UserChat.fromDocument(DocumentSnapshot doc){
    String aboutMe = "";
    String photoUrl = "";
    String nickname = "";
    //String phoneNumber = "";
    String username = "";
    String uid= '';
    //String email= '';
    String bio= '';

    try{
      aboutMe = doc.get(FirestoreConstants.aboutMe);
    }catch(e){}
    try{
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    }catch(e){}
    try{
      nickname = doc.get(FirestoreConstants.nickname);
    }catch(e){}
    try{
      aboutMe = doc.get(FirestoreConstants.phoneNumber);
    }catch(e){}
    return UserChat(
      id: doc.id,
      photoUrl: photoUrl,
      nickname: nickname,
      username: username,
      //email: email,
      bio: bio,
      followers: [],
      following: [],
    );
  }
}