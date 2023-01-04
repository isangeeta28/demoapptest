import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  //final String email;
  final String nickname;
  final String createdAt;
  final String id;
  //final String chattingWith;
 // final String uid;
  final String photoUrl;
  // final String bio;
  // final List followers;
  // final List following;

  const Users(
      {
     // required this.uid,
        required this.nickname,
        required this.id,
        required this.createdAt,
       // required this.chattingWith,
      required this.photoUrl,
      //required this.email,
      // required this.bio,
      // required this.followers,
      // required this.following
      });

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      createdAt: snapshot["createdAt"],
      id: snapshot["id"],
      //chattingWith: snapshot["chattingWith"],
     // email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      //bio: snapshot["bio"],
      // followers: snapshot["followers"],
      // following: snapshot["following"],
      //uid: snapshot["uid"],
      nickname: snapshot["nickname"],
    );
  }

  Map<String, dynamic> toJson() => {
       // "username": username,
        "nickname": nickname,
        "createdAt": createdAt,
        "id": id,
        //"chattingWith": chattingWith,
        //"uid": uid,
        //"email": email,
        "photoUrl": photoUrl,
        //"bio": bio,
        //"followers": followers,
        // "following": following,
      };
}
