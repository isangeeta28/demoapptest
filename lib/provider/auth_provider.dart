
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firestore_constants.dart';
import '../model/post.dart';
import '../model/user_chat.dart';
import 'package:demoprojectapp/model/users.dart' as model;

enum Status{
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  auhenicatedCancelled,
}

class AuthProvider extends ChangeNotifier{
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firabaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({
    required this.firabaseFirestore,
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
  });

  String? getUserFirebaseId(){
    return prefs.getString(FirestoreConstants.id);
  }

  Future<bool> isLoggedIn()async{
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if(isLoggedIn && prefs.getString(FirestoreConstants.id)?.isNotEmpty == true){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> handleSignIn()async{
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if(googleUser != null){
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if(firebaseUser != null){
        final QuerySnapshot result = await firabaseFirestore.collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
        .get();
        final List<DocumentSnapshot> document = result.docs;
        if(document.length == 0){
          firabaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).set({
            FirestoreConstants.nickname: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.phoneNumber: firebaseUser.phoneNumber,
            FirestoreConstants.id : firebaseUser.uid,
            FirestoreConstants.email: firebaseUser.email,
            'createdAt': DateTime.now().microsecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          await prefs.setString(FirestoreConstants.nickname, currentUser.displayName??"");
          await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL??"");
          await prefs.setString(FirestoreConstants.phoneNumber, currentUser.phoneNumber??"");
        }else{
           DocumentSnapshot documentSnapshot = document[0];
           UserChat userChat = UserChat.fromDocument(documentSnapshot);

           await prefs.setString(FirestoreConstants.id, userChat.id);
           await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
           await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      }else{
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
     }else{
      _status = Status.auhenicatedCancelled;
      notifyListeners();
      return false;
     }
    }

  // get user details
  Future<model.Users> getUserDetails() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot documentSnapshot = await firabaseFirestore.collection('users').doc(currentUser.uid).get();
    return model.Users.fromSnap(documentSnapshot);
  }

  Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot snapshot = await firabaseFirestore
        .collection('posts')
        .where('uid', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
  }

    Future<void> handleSignOut() async{
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    }
  }