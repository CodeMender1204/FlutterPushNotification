import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class HomePage extends StatelessWidget {
   HomePage({super.key});
    final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<String> getAccessToken() async {
  // Your client ID and client secret obtained from Google Cloud Console
  final serviceAccountJson = {
   //Your serviceAccoucnt Json Data
};

 List<String> scopes = [
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/firebase.database",
 "https://www.googleapis.com/auth/firebase.messaging"
];
 
 http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

  // Obtain the access token
  auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
    client
  );

  // Close the HTTP client
  client.close();

  // Return the access token
  return credentials.accessToken.data;

}

Future<void> sendFCMMessage() async {
  final String serverKey = await getAccessToken() ; // Your FCM server key
  final String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/flutterproject-82c7e/messages:send';
  final  currentFCMToken = await FirebaseMessaging.instance.getToken();
  print("fcmkey : $currentFCMToken");
  final Map<String, dynamic> message = {
    'message': {
      'token': currentFCMToken, // Token of the device you want to send the message to
      'notification': {
        'body': 'This is an FCM notification message!',
        'title': 'FCM Message'
      },
      'data': {
        'current_user_fcm_token': currentFCMToken, // Include the current user's FCM token in data payload
      },
    }
  };

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('FCM message sent successfully');
  } else {
    print('Failed to send FCM message: ${response.statusCode}');
  }
}



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
                  onPressed: () { sendFCMMessage();},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  child: const Text("send"),
                ),
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
