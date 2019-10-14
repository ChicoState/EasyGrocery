import 'package:flutter/material.dart';
import 'package:EasyGrocery/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'home_page.dart';
import 'login.dart';

class splash extends StatefulWidget {
  splash({this.auth});

  final BaseAuth auth;
  @override 
  State<StatefulWidget> createState() => new _SplashState();
}

enum AuthStatus { 
  Pending,
  Logged_in,
  Not_Logged_in,
}

class _SplashState extends State<splash> {
  AuthStatus authStatus = AuthStatus.Pending;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.Not_Logged_in : AuthStatus.Logged_in;
      });
    });
  }

void _signedOut() {
  setState(() {
    authStatus = AuthStatus.Not_Logged_in;
  });
}

void _signedIn() {
  setState(() {
    authStatus = AuthStatus.Logged_in;
  });
}

@override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.Pending:
        return _buildWaitingScreen();
      case AuthStatus.Not_Logged_in:
        return MyLoginPage(
          onSignedIn: _signedIn,
      );
      case AuthStatus.Logged_in:
        return MyHomePage(
          onSignedOut: _signedOut,  
      );
  }
  return null;
 }
  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
