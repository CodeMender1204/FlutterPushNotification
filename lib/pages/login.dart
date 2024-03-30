// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_demo/pages/Register.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),automaticallyImplyLeading: false, centerTitle: true,titleTextStyle: TextStyle(
        color: Colors.lightBlue[200],
        fontWeight: FontWeight.w800,
        fontSize: 28
      ),),
      body: ListView(
        children: [
          Column(
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
                child: const TextField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "Enter Email"),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Enter Password"),
                ),
              ),
               ElevatedButton(
                onPressed: () => print("clicked"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ),
                child: const Text("Submit"),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom:10),
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
                      onPressed: () => print("clicked"),
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
            TextButton(onPressed: ()=>{
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=> const RegisterPage())
              )
            }, child: Text("Register") )
          ],
         )


        ],
      ),
    );
  }
}
