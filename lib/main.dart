import 'package:flutter/material.dart';
import 'login.dart';
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
    return MaterialApp(
      title: 'EasyGrocery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      home: Splash(
      auth: new Auth(),
    ),
    );
  }
}


