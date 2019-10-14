import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'list.dart';
import 'auth.dart';
import 'splash.dart';

var page = MyLoginPage;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
      title: 'EasyGrocery',
      theme: ThemeData(
      ),
      home: Splash(),
    ),
    );
  }
}


