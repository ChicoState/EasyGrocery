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
    await tester.tap(find.byKey(Key('Walmart')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('compare')));
    await tester.pumpAndSettle();
    expect(find.text("Select at least two stores to compare prices."), findsOneWidget);
    await tester.tap(find.byKey(Key('escape')));
});

  //page testing for grocery list check off
  testWidgets('Item grocery list check off expire alert', (WidgetTester tester) async {
    BaseAuth testauth = new Auth();
    await tester.pumpWidget(new MaterialApp(home: Shoplist(auth: testauth, test: true,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('item0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('expire0')));
    await tester.pumpAndSettle();
    expect(find.text("Enter an expiration date so we can remind you"), findsOneWidget);
    await tester.tap(find.byKey(Key('escape')));
});

//will fail just to test that search code doesn't throw errors
  testWidgets('Search works', (WidgetTester tester) async {
    await tester.pumpWidget( new MaterialApp(home: new SearchList()));
    await tester.enterText(find.byKey(Key('search')), 'eggs');
    await tester.tap(find.byKey(Key('searchButton')));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });

  //test for search list clear
  testWidgets('Search clear works', (WidgetTester tester) async {
    await tester.pumpWidget( new MaterialApp(home: new SearchList()));
    await tester.tap(find.byKey(Key('search')));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });

  //Test that favorites menu opens
  testWidgets('Favorites menu opens', (WidgetTester tester) async {
    Auth testauth = new Auth();
    await tester.pumpWidget( new MaterialApp(home: new GroceryList(auth: testauth)));
    await tester.tap(find.byKey(Key("favButton")));
    await tester.pumpAndSettle();
    expect(find.text("Favorites"), findsOneWidget);
  });

  //Test that search menu opens
  testWidgets('search menu opens', (WidgetTester tester) async {
    Auth testauth = new Auth();
    await tester.pumpWidget( new MaterialApp(home: new GroceryList(auth: testauth)));
    await tester.tap(find.byKey(Key("addButton")));
    await tester.pumpAndSettle();
    expect(find.text("Add An Item"), findsOneWidget);
  });

  //test for main.dart
  /*testWidgets('Main.dart render test', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: MyApp()));
    await tester.pumpAndSettle();
//    expect(find.text("EasyGrocery"), findsOneWidget);
  });*/

  //page testing for compare page
  testWidgets('Class compare check', (WidgetTester tester) async {
    List<GroceryStores> _groceryStores = <GroceryStores>[];
    
    //Create static locations for now
    GroceryStores _walmart = 
    new GroceryStores("Walmart", "2044 Forest Ave.", "walmart.png", 0, 0);
    GroceryStores _safeway =
    new GroceryStores("Safeway", "Chico Placeholder", "safeway.png", 0, 0);
    _groceryStores.add(_walmart);
    _groceryStores.add(_safeway);
    BaseAuth testauth = new Auth();
    await tester.pumpWidget(new MaterialApp(home: Compare(test: true, auth: testauth, groceryStores: _groceryStores, 
    )));
    await tester.pumpAndSettle();
});
}