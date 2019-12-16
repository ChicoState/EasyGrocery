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

  //test that login works
  void testfunc(){
      print("Testing");
  }
  //auth page testing for signout
  testWidgets('Auth page working on signout', (WidgetTester tester) async {
    BaseAuth testauth = new Auth();
    Key temp;
    await tester.pumpWidget( new MaterialApp(home: MyHomePage(auth: testauth, title: "EasyGrocery", onSignedOut: testfunc, key: temp,)));
    await tester.tap(find.byKey(Key('settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('logout')));
    await tester.pumpAndSettle();
});

  //auth page testing for register
  testWidgets('Auth page working on registering user', (WidgetTester tester) async {
    final BaseAuth testauth = new Auth();
    testauth.createUserWithEmailAndPassword("test@gmail.com", "admin5");
});

//page testing for grocery list
  testWidgets('Class grocery list check', (WidgetTester tester) async {
    BaseAuth testauth = new Auth();
    await tester.pumpWidget(new MaterialApp(home: Prices(auth: testauth,
      callback: (newPage) {},
      reset: () {}
    )));
    await tester.pumpAndSettle();
    print("testing!!!!!");
    await tester.tap(find.byKey(Key('Walmart')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('compare')));
    await tester.pumpAndSettle();
    expect(find.text("Select at least two stores to compare prices."), findsOneWidget);
});
}