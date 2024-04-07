

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/pages/Home.dart';
import 'package:flutter_application_demo/pages/login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpswdController = TextEditingController();

  Future<void> signUpAndSaveUserData(
      String emailAddress, String password, String username,BuildContext context) async {
    try {
      // Create user with email and password
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // Save user data to Realtime Database
      await saveUserData(credential.user!.uid, emailAddress, username);
       Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
      // You may add additional actions upon successful authentication here
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveUserData(
      String userId, String emailAddress, String username) async {
    try {
      // Get a reference to the database
      final databaseReference = FirebaseDatabase.instance.reference();

      // Save user data
      await databaseReference.child('users').child(userId).set({
        'email': emailAddress,
        'username': username,
        // Add more user data fields as needed
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.lightBlue[200],
            fontWeight: FontWeight.w800,
            fontSize: 28),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/sign-up-form.svg",
                  width: 305,
                  height: 305,
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.redAccent, width: 1)),
                        child: IconButton(
                            onPressed: () => print("clicked"),
                            icon: const Icon(FontAwesomeIcons.google,
                                color: Colors.redAccent, size: 30.0)),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.blueAccent, width: 1)),
                        child: IconButton(
                            onPressed: () => print("clicked"),
                            icon: const Icon(FontAwesomeIcons.facebook,
                                color: Colors.blueAccent, size: 30.0)),
                      ),
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1)),
                          child: IconButton(
                            onPressed: () => print("clicked"),
                            icon: const Icon(FontAwesomeIcons.twitter,
                                color: Colors.lightBlueAccent, size: 30.0),
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The username is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter Username"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The email is required';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(), labelText: "Enter Email"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The password is required';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: confirmpswdController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Confirm Password"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      final String username = usernameController.text;
                      final String emailAddress = emailController.text;
                      final String password = passwordController.text;
                      signUpAndSaveUserData(emailAddress, password, username,context);
                     
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue[100]),
                      foregroundColor: MaterialStatePropertyAll(Colors.white)),
                  child: const Text("Register"),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  LoginPage()))
                        },
                    child: Text("LogIn"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
