import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'main.dart';
import 'login.dart';
import 'register.dart';


class GroceryListState extends State<GroceryList> {
  //variables for this class
  String _searchString = "";
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[""];
  //set to contain all favorited items
  Set<String> _favorites = Set<String>();
  final TextStyle _itemFont = const TextStyle(fontSize: 18.0);
  //text controller used to clear text form
  final TextEditingController _textController = new TextEditingController();

  //List to hold all items in search menu
  List<String> _searchList = new List<String>();
  
  

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
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child:Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: new Text("${_groceryList.length-1} items")
              ),
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
      )
    );
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
    if(item == ""){
      return ListTile();
    }
    else{
      return Card( 
        child: ListTile(
        title: Text(
          item,
          style: _itemFont,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
              color: alreadySaved ? Colors.red : null,
              onPressed: () {
                setState(() {
                  if(alreadySaved){
                    _favorites.remove(item);
                  }
                  else{
                    _favorites.add(item);
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  _groceryList.remove(item);
                });
              },
            ),
          ]
        ),
      ));
    }
  }

  ///_searchMenu function
  ///Displays a page where the user can search for an item in our database
  ///and then add that item to the list
  void _searchMenu() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Colors.black),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Text("Add An Item", style: TextStyle(color: Colors.black)),
            ),
            body: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      _searchString = value;
                    },
                    controller: _textController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  )),
              //Search button
              MaterialButton(
                onPressed: () {
                  FocusScope.of(context).unfocus(); //dismiss keyboard
                  _search();
                },
                elevation: 5,
                minWidth: 200,
                color: Colors.greenAccent,
                //Labels the button with search
                child: Text('Search'),
              ),
              //List of items to add
              Expanded(child: _buildSearchList(), ),
            ]),
          );
        },
      ),
    );
  }

  /// search function
  /// for now just adds item to search list
  /// later with grab items from database
  void _search() {
    print("Search");
    setState(() {
      //clear current search list
      _searchList = new List<String>();
      if (_searchString != "") {
        _searchList.insert(0, _searchString);
      }
      //clear text
      _textController.clear();
    });
  }

  /// _buildSearchList function
  /// builds a list of items that are similar to what the user has searched for
  Widget _buildSearchList() {
    return ListView.builder(
        key: UniqueKey(),
        padding: const EdgeInsets.all(10.0),
        //number of items is the size of our list
        itemCount: _searchList.length,
        itemBuilder: (context, i) {
          //build each individual row
          return _buildSearchRow(_searchList[i]);
        });
  }

  ///buildSearchRow function
  /// builds each individual row of the seach list that is displayed to the user
  //function to build each individual row of grocery list
  Widget _buildSearchRow(String item) {
    return Card(
      child: ListTile(
      title: Text(
        item,
        style: _itemFont,
      ),
      trailing: IconButton(
        icon: Icon(_groceryList.contains(item) ? (Icons.check_circle) :(Icons.add)),
        color: Colors.green,
        onPressed: ()  {
          _addItem(item);
        },
      ),
      ),
    );
  }

  ///addItem function:
  ///Adds an item to the grocery list
  ///@param{String} itemName the name of the item to add to the list
  void _addItem(String itemName) {
      setState(() {
        //no duplicate items in list
        if(! _groceryList.contains(itemName)){
          _groceryList.insert(0, itemName);
          _searchList = new List.from(_searchList)..remove(itemName);
        }
        _textController.clear();
        _searchString = "";
        print("List size = " + _searchList.length.toString() );
      });
  }

  void _favoritesMenu(){
  Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<Card> tiles = _favorites.map(
            (String item){
              return Card( child:ListTile(
                title: Text(
                  item,
                  style: _itemFont,
                ),
              ));
            }
          );

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




class GroceryList extends StatefulWidget {
  @override
  GroceryListState createState() => GroceryListState();
}