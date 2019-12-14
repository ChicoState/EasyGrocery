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


  //test that login works
  void testfunc(){
      print("Testing");
  }

  testWidgets('Login works', (WidgetTester tester) async {
    BaseAuth testauth = new Auth();
    await tester.pumpWidget( new MaterialApp(home: MyLoginPage(auth: testauth, title: "EasyGrocery", onSignedIn: testfunc)));
    //click username and input
    await tester.enterText(find.byKey(Key('email')), 'easygrocery5@gmail.com');
    await tester.enterText(find.byKey(Key('Password')), 'admin5');
    await tester.tap(find.byKey(Key('submit')));
    await tester.pump();

    expect(find.widgetWithText(AppBar, 'EasyGrocery'), findsOneWidget);

    //click password and input


  });

  testWidgets('Register button works', (WidgetTester tester) async {
    BaseAuth testauth = new Auth();
    await tester.pumpWidget( new MaterialApp(home: MyLoginPage(auth: testauth, title: "EasyGrocery", onSignedIn: testfunc)));

    await tester.tap(find.byKey(Key('register')));
    await tester.pumpAndSettle();
    
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);

  });

  testWidgets('Register page works', (WidgetTester tester) async {
    BaseAuth testauth = new Auth();
    await tester.pumpWidget( new MaterialApp(home: MyLoginPage(auth: testauth, title: "EasyGrocery", onSignedIn: testfunc)));

    await tester.tap(find.byKey(Key('register')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('fname')), "Test");
    await tester.enterText(find.byKey(Key('lname')), "McTest");
    await tester.enterText(find.byKey(Key('email')), "thisIsATest");
    await tester.enterText(find.byKey(Key('pass')), "testing4us");
    await tester.enterText(find.byKey(Key('confpass')), "testing4us");

    await tester.tap(find.byKey(Key('register')));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'EasyGrocery'), findsOneWidget);


  });

  //test for homepage appbar header
  testWidgets('Check appbar head on homepage', (WidgetTester tester) async {
      BaseAuth testauth = new Auth();
      await tester.pumpWidget(new MaterialApp( home: new MyHomePage(
            auth: testauth,
            title: "EasyGrocery",
      )));
      expect(find.widgetWithText(AppBar, 'EasyGrocery'), findsOneWidget);
    });
}
