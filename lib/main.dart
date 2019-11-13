import 'package:flutter/material.dart';
import 'login.dart';
import 'auth.dart';
import 'splash.dart';
import 'package:flutter/services.dart';

var page = MyLoginPage;

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyGrocery',
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      home: Splash(
      auth: new Auth(),
    ),
    );
  }
}


