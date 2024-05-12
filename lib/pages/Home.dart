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
  "type": "service_account",
  "project_id": "flutterproject-82c7e",
  "private_key_id": "de26427587e24dd4c7e400757991de67e703e8aa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCyunCB1O0SoPS3\nYzPEJElQgXqz8aeEKq0SFPk5pNGbx0bE2iuiriCJhsSWfHrXHaM924JdAqVtHNFX\nNPI3QyicwmuqiQjLz3r1Fhmxrb/rJ0UmphGHtH6RcrgXBGlABj8IwKskVF8SpJTx\nibwXgBDtrFBoByf477bhFQUF26XAu6PwQKt83c653cfXGBiPgxt8r4Dzk0GkbCFx\nvyCYfUUokImz3TVv2QGCRfGN12o5+CC9o3vw5i/iGbpaqiG+vXzMq6E0Z1iWOTmZ\nwsTp9KTBcttFUDWO8NqLN4rWBTdM6I0DhamA5zO7xO2rUhNRA2o4J3sKceJxJrRj\nC1kW99LhAgMBAAECggEAA1LHbQibLGuhBUhzUdg9Y0F3GUG69FCRVYrdjAJ6Mc/5\nq0clxNGBUiFXBjfUFmwrCQdMBCP8lLvykhEuWFP3vTt5wkroRpbp8cT6jxTcotgg\n92wi2w/CgzybevUWam37TdO8UvF9L5TvHpMps9OqLOs1dwu8BOtbLpIEHQTlrwDe\nP9l8iNX+AIIgJcoJB/btGygBeHheH4cLb3z0NI8/CeAbLs8hhh50ESpQ1jF9S2ck\n8wA7UWdgnGdDbF4LCt+dQx1qtuEG6z2JYR/cPf+H2322DiH/GGCHKRNXqzgdvH4z\no0JIzX36YFhQiVBftuxBwm0omcDNDLnzmkq3pGM0oQKBgQDfy/VWKbriFZexrbkD\nlrQXSGhEmM8CljcWLF/m6cboSQOxA06ZVmMAlM9wtB38RzqLi8QOItNI5y5kAQxa\n5cCdoKVwRHlH56BMJT22jlKQ2yX1NO131cQ4Kihb9gwwhBMF/WnSsifI0A7BBPie\nzKp8kVCvxHPyKhVKPu/q30jeMQKBgQDMcklqG1SJHp1JW8bX1ztzoWnzLO0IiZA/\n6eHZmPrg4OKfaPzT+pXDqpsHgVixiRY2SkgwMuuW229MqMSvd9/8CPuydrhADL7f\ngQVwSBdvClb482k7UikHZwT+6a5oUGxA5OGOpFvsXN/fXlbto/Ft3NhPt3OzFpEz\neJFmea2jsQKBgBQvWi5uTxvLJMZyy8gmFJIxBq6BNdKe59MJJ5E1LqqOw1V43eL4\npq9LvLYGmNnDNuWVMpavz2y45TdB3PJp3IibD7DjjCjPHGchyMIpbgsAqRjHsE9p\nqWwDaWZ597l8gBa/N4c4aFw1X89K+n2gKhRYKvXfezGxWAA9UvhVMUZRAoGABhLj\nIXbcZRJ2w8YpOyJWztGdzy6ngBhuI6f0IL3Nvj6QHQJGeJm6N0zrPCbYlrWm5kgA\nqwXoP9wXC2T8KuZZzigKKjwiryxxwzwXCEXsBE1/VfgNSUjglSq3WEdi+hBhlu/1\nz4IMhRIhSIaJ+JdlRclI191wX4KtH6VWVIAK65ECgYAfoBB9gu8i416goptMxbEE\n7QSrnm0nwPFq2JhJ89unUnP69OxR9904ur4+fCDQ7/xALnXQubC8EUKtguRx3CuB\n4uVANq+cs9od+XGUeROhp2I+6qVMLLtovtz5W9S/Qa2Oxyk+By2vmQWwsMKZhppA\ndbTkAhot+x7FI7FRHb+CAA==\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-jku4p@flutterproject-82c7e.iam.gserviceaccount.com",
  "client_id": "111064063932577348257",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jku4p%40flutterproject-82c7e.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
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