import 'package:demoprojectapp/views/home_screen.dart';
import 'package:demoprojectapp/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
      checkSignedIn();
    });
  }

  void checkSignedIn()async{
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 250,),
                Text('Instagram',
                  style: TextStyle(fontSize: 65, color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                SizedBox(height: 40,),
                CircularProgressIndicator(),
              ],
            ),
          )
      ),
    );
  }
}