import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'auth.dart';
import 'search.dart';
//Firebase Database
import 'package:firebase_database/firebase_database.dart';

class GroceryList extends StatefulWidget {
  GroceryList({this.auth});
  final BaseAuth auth;

  @override
  GroceryListState createState() => GroceryListState();
}


class GroceryListState extends State<GroceryList> {
  //Firebase database reference
  final dbRef = FirebaseDatabase.instance.reference();
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[];
  //set to contain all favorited items
  Set<String> _favorites = Set<String>();
  //Text styling for list tiles
  final TextStyle _itemFont = const TextStyle(fontSize: 18.0);
  //List to store items from Firebase side
  List<dynamic> items = [];
  //User's UID
  String uid = "";

  //Calls this to initialize the above two variables
  void initState() {
    initializeVars();
    super.initState();
  }

  //override the build function
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildGroceryList(),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 30),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    heroTag: "addButton",
                    onPressed: _searchMenu,
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Center(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: new Text("${_groceryList.length} items")),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "favButton",
                onPressed: _favoritesMenu,
                child: Icon(Icons.list),
                backgroundColor: Colors.green,
              ),
            )
          ],
        ));
  }

  //function to build grocery list from _groceryList variable
  Widget _buildGroceryList() {
    return ListView.builder(
        key: UniqueKey(),
        padding: const EdgeInsets.all(10.0),
        //number of items is the size of our list
        itemCount: _groceryList.length,
        itemBuilder: (context, i) {
          //build each individual row
          return _buildGroceryRow(_groceryList[i]);
        });
  }

  //function to build each individual row of grocery list
  Widget _buildGroceryRow(String item) {
    final bool alreadySaved = _favorites.contains(item);
    //if else statement pads the bottom of the list so buttons don't cover items in list
    if (item == "") {
      return ListTile();
    } else {
      return Card(
          child: ListTile(
        title: Text(
          item,
          style: _itemFont,
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          IconButton(
            icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
            color: alreadySaved ? Colors.red : null,
            onPressed: () {
              setState(() {
                if (alreadySaved) {
                  _favorites.remove(item);
                } else {
                  _favorites.add(item);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.black,
            onPressed: () {
              removeFB(item);
              setState(() {
                _groceryList.remove(item);
              });
            },
          ),
        ]),
      ));
    }
  }

  //addItemCallback function
  //This function is passed to the child searchMenu
  //so that it can update the grocerylist
  void _addItemCallback(String item) {
    addFB(item);
    setState(() {
      _groceryList.insert(0, item);
    });
  }

  ///_searchMenu function
  ///Displays a page where the user can search for an item in our database
  ///and then add that item to the list
  void _searchMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SearchList(
              groceryList: _groceryList, addCallback: _addItemCallback)),
    );
  }

//Initialize variables UID and Item list
  Future initializeVars() async {
    uid = await widget.auth.currentUser();
    await dbRef.child("$uid/items").once().then((DataSnapshot data) {
      items = data.value;
        if(items != null){
          if (!mounted)
            return;
          setState(() {
            var tempo = new List<String>.from(items.cast<String>().toList());
            _groceryList = tempo;
          });
      }
      else{
        items = new List<String>();
      }
    });
  }

//Add to Firebase
  void addFB(String itemName) {
    //cast items to list of strings and build new list
    var tempo = new List<String>.from(items.cast<String>().toList());
    tempo.add(itemName);
    dbRef.child(uid).set({
      'items': tempo,
    });
    initializeVars();
  }

//Remove from Firebase
  void removeFB(String itemName) {
    var tempo = new List<String>.from(items);
    tempo.remove(itemName);
    dbRef.child(uid).set({
      'items': tempo,
    });
    initializeVars();
  }

  void _favoritesMenu() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<Card> tiles = _favorites.map((String item) {
            return Card(
                child: ListTile(
              title: Text(
                item,
                style: _itemFont,
              ),
            ));
          });

          final List<Widget> favorited = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Colors.black),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Text(
                "Favorites",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: ListView(children: favorited),
          );
        },
      ),
    );
  }
} //GroceryListState
