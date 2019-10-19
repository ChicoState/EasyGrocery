import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'login.dart';
import 'register.dart';
import 'list.dart';
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
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      home: Splash(
      auth: new Auth(),
    ),
    );
  }
}


<<<<<<< HEAD
=======

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  
  static int _currentIndex = 0; //index of current tab
  //List of widgets to be displayed for each tab
  final List<Widget> _pages = [
    PlaceHolderWidget(Colors.white),
    GroceryList(),
    PlaceHolderWidget(Colors.green)
  ];

  //controller for circular bottom nav bar
  CircularBottomNavigationController _navigationController = 
  new CircularBottomNavigationController(_currentIndex);
  //List of tabItems for circulatr bottom navigation bar
  List<TabItem> tabItems =  List.of([
    new TabItem(Icons.home, "Home", Colors.green, labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.green),),
    new TabItem(Icons.library_books, "List", Colors.green, labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.green)),
    new TabItem(Icons.monetization_on, "Prices", Colors.green, labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.green)),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Used to open the drawer by affecting the state of the scaffold
      key: _drawerKey,
      appBar: AppBar(
        //Icon button that acts as a settings to logout under
        actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, color: Colors.black,),
          onPressed: () => _drawerKey.currentState.openEndDrawer()
          ),],
        //Removes automatic back button on page
        automaticallyImplyLeading: false,
        //centers the name of the app on the appbar
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.white,
        title: Text(widget.title),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.greenAccent, fontSize: 25.0, fontFamily: 'roboto')
        ),
      ),
      //Adds a drawer on the side that will act as a settings page
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
            child: DrawerHeader(
              child: Text('Settings'),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
            ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MyLoginPage(title: 'EasyGrocery')),
                );
              },
            ),
            ListTile(
              title: Text('Close'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ]
      )),

      //body
      body: _pages[_currentIndex],

      //Adds Navigation bar to the bottom of the app screen
      bottomNavigationBar: CircularBottomNavigation(
        tabItems,
        controller: _navigationController,
        selectedCallback: (int selectedPos){
          //call set state and update index of current page
          setState(() {
            _navigationController.value = selectedPos;
            _currentIndex = selectedPos;
          });
        },
      )
    );
  }

  void changeTab(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}

class PlaceHolderWidget extends StatelessWidget{
  final Color color;
  PlaceHolderWidget(this.color);

  @override
  Widget build(BuildContext context){
    return Container(
      color: color,
    );
  }
}
>>>>>>> 1c5b2051233a840934cfeafc882aab8d6da20a48
