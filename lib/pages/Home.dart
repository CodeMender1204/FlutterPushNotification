import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
    final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleSignOut(BuildContext context) async {
    try {
      FirebaseAuth.instance.signOut(); 
      await _googleSignIn.signOut();
      // After sign out, navigate to the login or home screen
      Navigator.push(context,MaterialPageRoute(builder: (context)=>  LoginPage())); // Replace '/login' with your desired route
    } catch (error) {
      print("Error signing out: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text("Home Page"),automaticallyImplyLeading: false, centerTitle: true,titleTextStyle: TextStyle(
        color: Colors.lightBlue[200],
        fontWeight: FontWeight.w800,
        fontSize: 28
      ),),
      body:Container(
        margin: EdgeInsets.only(left: 160),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                  onPressed: () { _handleSignOut(context);},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  child: const Text("LogOut"),
                )],
        ),
      ) ,
    );
  }
}