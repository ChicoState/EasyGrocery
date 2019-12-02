import 'auth.dart';
import 'list.dart';
import 'prices.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({this.onSignedOut, Key key, this.title, this.auth})
      : super(key: key);
  final VoidCallback onSignedOut;
  final String title;
  final BaseAuth auth;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _signOut(BuildContext context) async {
    try {
      await widget.auth.signOut();

      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  //Initiate list of pages to display to the body
  final List<Widget> _pages = new List(4);

  //Function to check if previously compared and added
  //new page so you don't have to keep clicking compare
  bool checkCompare(int index) {
    if (_pages[3]==null || index != 2)
      return true;
    else
      return false;
  }


  //Boolean to re-render the page
  bool rerender = false;

  //String uid = widget.auth.currentUser().toString();
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  static int _currentIndex = 0;

  //controller for circular bottom nav bar
  CircularBottomNavigationController _navigationController =
      new CircularBottomNavigationController(_currentIndex);
  //List of tabItems for circulatr bottom navigation bar
  List<TabItem> tabItems = List.of([
    new TabItem(
      Icons.home,
      "Home",
      Colors.green,
      labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.green),
    ),
    new TabItem(Icons.library_books, "List", Colors.green,
        labelStyle:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.green)),
    new TabItem(Icons.monetization_on, "Prices", Colors.green,
        labelStyle:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.green)),
  ]);

  @override
  Widget build(BuildContext context) {
    //_pages.add(HomeScreen());
    _pages[0] = HomeScreen();
    //_pages.add(GroceryList(auth: widget.auth));
    _pages[1] = GroceryList(auth: widget.auth);
    _pages[2] = Prices(auth: widget.auth,
      callback: (newPage) {
        //Replace page with widget so bottom appbar remains
        setState(() {
          _pages[3] = newPage;
          _currentIndex = 3;
        });
      },
      //Replace page with price widget upon clicking reset
      reset: () {
        try {
          setState(() {
            _pages[3] = null;
            _currentIndex = 2;
          });
        } catch (e) { print(e);}
      }
    );

    return Scaffold(
        //Used to open the drawer by affecting the state of the scaffold
        key: _drawerKey,
        appBar: AppBar(
          //Icon button that acts as a settings to logout under
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onPressed: () => _drawerKey.currentState.openEndDrawer()),
          ],
          //Removes automatic back button on page
          automaticallyImplyLeading: false,
          //centers the name of the app on the appbar
          centerTitle: true,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          backgroundColor: Colors.white,
          title: Text(widget.title),
          textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 25.0,
                  fontFamily: 'roboto')),
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
                  color: Colors.green,
                ),
              ),
                  ),
              ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    _signOut(context);
                  }),
              ListTile(
                title: Text('Close'),
                onTap: () {
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ])),

        //body
        body: checkCompare(_currentIndex) ? _pages[_currentIndex]: _pages[3],

        //Adds Navigation bar to the bottom of the app screen
        bottomNavigationBar: CircularBottomNavigation(
          tabItems,
          controller: _navigationController,
          selectedCallback: (int selectedPos) {
            //call set state and update index of current page
            setState(() {
              _navigationController.value = selectedPos;
              _currentIndex = selectedPos;
            });
          },
        ));
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class PlaceHolderWidget extends StatelessWidget {
  final Color color;
  PlaceHolderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

//Basic homescreen with welcome text and app image
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[ 
            Padding(
              padding: const EdgeInsets.all(20.0),
              child:Center(
                child: Text("Welcome to Easygrocery", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))
              ),
            ),
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('assets/appicon.png', fit: BoxFit.fill)
            )
          ]
        ),
    );
  }
}
