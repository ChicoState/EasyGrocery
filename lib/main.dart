import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'list.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
//        primarySwatch: Colors.,
      ),
      home: MyLoginPage(title: 'EasyGrocery'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  //final titlecolor = const Color(0x03FC94);
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  void submit(){
    print("sup");
  }

  /*void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  } */

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            DrawerHeader(
              child: Text('Settings'),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
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
      //Adds Navigation bar to the bottom of the app screen
      bottomNavigationBar: BottomAppBar (
        //color: Colors.greenAccent,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child:
            IconButton(icon: Icon(Icons.local_grocery_store),  iconSize: 30, onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => GroceryList()),);  
            },),),
            Expanded(child:
            IconButton(icon: Icon(Icons.save),  iconSize: 30, onPressed: () {
            },),),
            Expanded(child:
            IconButton(icon: Icon(Icons.monetization_on), iconSize: 30, onPressed: () {},),)
        ],
        )

      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Creates a smiley icon that on press creates an alert
            IconButton(icon: Icon(Icons.sentiment_very_satisfied),
            iconSize: 50,
            tooltip: 'hello world',
            //Code below brings up an alert box that says hello world
            onPressed: () {
              return showDialog<void>(
                context: context,
                builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hello World'),
              );
                }
              );
            },
            ),
          ],
        ),
      ),
    );
  }
}
