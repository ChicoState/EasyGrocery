import 'package:flutter/material.dart';
import 'package:EasyGrocery/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'home_page.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  Splash({this.auth});

  final BaseAuth auth;
  @override 
  State<StatefulWidget> createState() => new _SplashState();
}

enum AuthStatus { 
  Pending,
  Logged_in,
  Not_Logged_in,
}

class _SplashState extends State<Splash> {
  AuthStatus authStatus = AuthStatus.Pending;
  //String _userId = "";


   initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.Not_Logged_in : AuthStatus.Logged_in;
      });
    });
   }



void _signedOut() {
  setState(() {
    authStatus = AuthStatus.Not_Logged_in;
    //_userId = "";
  });
}

void _signedIn() {
  setState(() {
    authStatus = AuthStatus.Logged_in;
  });
}

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.Pending:
        return _buildWaitingScreen();
      case AuthStatus.Not_Logged_in:
        return MyLoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
          title: "EasyGrocery",
      );
      case AuthStatus.Logged_in:
        return MyHomePage(
          auth: widget.auth, 
          onSignedOut: _signedOut,
          title: "EasyGrocery",  
      );
  }
  return null;
 }

}
