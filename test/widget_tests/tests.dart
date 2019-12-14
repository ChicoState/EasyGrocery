import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:EasyGrocery/auth.dart';
import 'package:EasyGrocery/home_page.dart';
import 'package:EasyGrocery/list.dart';
import 'package:EasyGrocery/login.dart';
import 'package:EasyGrocery/main.dart';
import 'package:EasyGrocery/prices.dart';
import 'package:EasyGrocery/register.dart';
import 'package:EasyGrocery/search.dart';
import 'package:EasyGrocery/shoplist.dart';
import 'package:EasyGrocery/splash.dart';


void main(){
  
  //test that Login page looks right
  testWidgets('Login screen looks right', (WidgetTester tester) async {
    await tester.pumpWidget( new MaterialApp(home: MyLoginPage(title: "EasyGrocery")) );
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  //test that register page looks right
  testWidgets('Register screen looks right', (WidgetTester tester) async {
    await tester.pumpWidget( new MaterialApp(home: MyRegisterPage(title: "EasyGrocery")) );
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });

  //test for homepage appbar header
  testWidgets('Check appbar head on homepage', (WidgetTester tester) async {
      BaseAuth testauth;
      await tester.pumpWidget(new MaterialApp( home: new MyHomePage(
            auth: testauth,
            title: "EasyGrocery",
      )));
      expect(find.widgetWithText(AppBar, 'EasyGrocery'), findsOneWidget);
    });
}
