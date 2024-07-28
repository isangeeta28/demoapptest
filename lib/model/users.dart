import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String nickname;
  final String createdAt;
  final String id;
  final String photoUrl;

  const Users(
      {
        required this.nickname,
        required this.id,
        required this.createdAt,
      required this.photoUrl,
      });

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      createdAt: snapshot["createdAt"],
      id: snapshot["id"],
      photoUrl: snapshot["photoUrl"],
      nickname: snapshot["nickname"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "createdAt": createdAt,
        "id": id,
        "photoUrl": photoUrl,
      };
}
