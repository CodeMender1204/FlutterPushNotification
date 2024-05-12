// ignore_for_file: avoid_print


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_demo/pages/Home.dart';
import 'package:flutter_application_demo/pages/Register.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> signInWithEmailAndPassword(
      String emailAddress, String password, BuildContext context) async {
    try {
      // Sign in with email and password
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      // Additional actions upon successful login can be added here
      print('User logged in successfully: ${credential.user!.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // User canceled the sign-in process
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Save user data to database
    await saveUserData(userCredential.user);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future<void> saveUserData(User? user) async {
    if (user == null) {
      return;
    }

    // Get a reference to the database
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference();

    // Save user data
    await databaseReference.child('users').child(user.uid).set({
      'displayName': user.displayName,
      'email': user.email,
      // Add more user data fields as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.lightBlue[200],
            fontWeight: FontWeight.w800,
            fontSize: 28),
      ),
      body: ListView(
        children: [
          Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/authentication.svg",
                  width: 305,
                  height: 305,
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
                        border: UnderlineInputBorder(),
                        labelText: "Enter Email"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The password is required';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter Password"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      final String emailAddress = emailController.text;
                      final String password = passwordController.text;
                      signInWithEmailAndPassword(
                          emailAddress, password, context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue[100]),
                      foregroundColor: MaterialStatePropertyAll(Colors.white)),
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 1)),
                  child: IconButton(
                      onPressed: () {
                        signInWithGoogle(context);
                      },
                      icon: const Icon(FontAwesomeIcons.google,
                          color: Colors.redAccent, size: 30.0)),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 1)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Don't have an account yet?"),
              TextButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()))
                      },
                  child: Text("Register"))
            ],
          )
        ],
      ),
    );
  }
}
