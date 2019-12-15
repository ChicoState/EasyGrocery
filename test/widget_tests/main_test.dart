import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
