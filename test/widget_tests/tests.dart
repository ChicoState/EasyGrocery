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
  //calling test widget
 testWidgets('validate appBar string', (WidgetTester tester) async {
   //set up what to test static on the widget
   // creates a temporary widget to find
   await tester.pumpWidget(MaterialApp(
       home: Scaffold(
         //appbar text
         appBar: AppBar(
           title: Text('EasyGrocery'),
         ),
       )
   ));
   //
   expect(find.text('EasyGrocery'), findsOneWidget);
 });

 testWidgets('Check appbar head', (WidgetTester tester) async {
    await tester.pumpWidget(new MyHomePage());
    expect(find.widgetWithText(AppBar, 'EasyGrocery'), findsOneWidget);
  });
}
