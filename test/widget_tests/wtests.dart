import 'package:EasyGrocery/main.dart' as prefix0;
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

import 'main_test.dart' as prefix1;




void main(){
  //shoplist test
  //testWidgets('Shoplist list text', (WidgetTester tester) async {
  //  Auth test_auth = new Auth();
   // await tester.pumpWidget(new MaterialApp(home: Shoplist(auth: test_auth)));
   // await tester.tap(find.byKey(Key('register')));
   // await tester.pumpAndSettle();
   // expect(find.text("Your Grocery List"), findsOneWidget);
  //});


  //test main static
  testWidgets('EasyGrocery title', (WidgetTester tester) async{
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          //appbar text
          appBar: AppBar(
            title: Text('EasyGrocery'),
          ),
        )
    ));
    expect(find.text('EasyGrocery'), findsOneWidget);
  });



}