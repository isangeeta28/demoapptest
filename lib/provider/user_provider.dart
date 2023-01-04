// import 'package:demoprojectapp/model/users.dart';
// import 'package:demoprojectapp/provider/auth_provider.dart';
// import 'package:flutter/widgets.dart';
//
// class UserProvider with ChangeNotifier {
//   Users? _user;
//   late final AuthProvider _authMethods;
//
//   Users? get getUser => _user;
//
//   Future<void> refreshUser() async {
//     Users user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }