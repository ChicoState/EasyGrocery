import 'auth.dart';
import 'list.dart';
import 'login.dart';
import 'package:flutter/material.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({this.onSignedOut, Key key, this.title, this.auth}) : super(key: key);
  final VoidCallback onSignedOut;
  final String title;
  final BaseAuth auth;

   /* Future<void> _signOut(BuildContext context) async {
    try {Future<void> 
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  */

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final VoidCallback onSignedOut;
   _signOut(BuildContext context) async {
    try {
      //final BaseAuth auth = AuthProvider.of(context).auth;
      await widget.auth.signOut();
      
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  int _currentIndex=0;
  final List<Widget> _pages = [
    PlaceHolderWidget(Colors.white),
    GroceryList(),
    PlaceHolderWidget(Colors.green)
  ];

  //Future<void> _signOut()
  

  void submit(){
    print("sup");
  }


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
                //Navigator.pop(context);
                _signOut(context);
                
              }
                //Navigator.push(context,
                //new MaterialPageRoute(builder: (context) => MyLoginPage(title: 'EasyGrocery')),
              //}
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
      bottomNavigationBar: BottomNavigationBar (
        onTap: changeTab,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Text('List'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.monetization_on),
            title: new Text('Prices'),
          ),
        ],

      ),
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
