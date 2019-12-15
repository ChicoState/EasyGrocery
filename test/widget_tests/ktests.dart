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
    await tester.pumpWidget( new MaterialApp(home: MyLoginPage(auth: testauth, title: "EasyGrocery", onSignedIn: testfunc)));
    //click username and input
    await tester.enterText(find.byKey(Key('email')), 'easygrocery5@gmail.com');
    await tester.enterText(find.byKey(Key('Password')), 'admin5');
    await tester.tap(find.byKey(Key('submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('settings')));
    await tester.tap(find.byKey(Key('logout')));
    await tester.pumpAndSettle();
});
}