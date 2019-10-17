import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'main.dart';
import 'login.dart';
import 'register.dart';


class GroceryListState extends State<GroceryList> {
  //variables for this class
  String _itemToAdd;
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[""];
  //set to contain all favorited items
  Set<String> _favorites = Set<String>();
  final TextStyle _itemFont = const TextStyle(fontSize: 18.0);
  //global formkey for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //text controller used to clear text form
  final TextEditingController _textController = new TextEditingController();
  
  

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
                onPressed: _addMenu,
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
        padding: const EdgeInsets.all(10.0),
        //number of items is the size of our list
        itemCount: _groceryList.length,
        itemBuilder: (context, i) {
          //build each individual row
          return _buildRow(_groceryList[i]);
        });
  }

  //function to build each individual row of grocery list
  Widget _buildRow(String item) {
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

  void _addMenu() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Colors.black),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Text("Add An Item"),
            ),
            body: Form(
              key: _formKey,
              child: new Container(
                padding: new EdgeInsets.all(25.0),
                //Added a column in the center of the screen
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Added textboxes with an icon
                      //item textfield
                      TextFormField(
                        controller: _textController,
                        decoration: new InputDecoration(
                          icon: Icon(Icons.add_shopping_cart, color: Colors.black),
                          helperText: "Item Name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                        ),
                        cursorColor: Colors.black,
                        validator: (input){
                          if (input.isEmpty) {
                            return "Please enter an item.";
                          }
                        },
                        onSaved: (input) => _itemToAdd = input,
                      ),
                      MaterialButton(
                        //Login button with styling
                        onPressed: addItem,
                        elevation: 5,
                        minWidth: 200,
                        color: Colors.greenAccent,
                        //Labels the button with Submit
                        child: Text('Add'),
                      ),
                    ]
                  )
              ),
            )
          );
        },
      ),
    );
  }

  void addItem() {
    var formState = _formKey.currentState;
    formState.save();
    if (_itemToAdd != "") {
      _groceryList.insert(0, _itemToAdd);
    }
    _textController.clear();
    _itemToAdd = "";
  }


  void _favoritesMenu(){
  Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _favorites.map(
            (String item){
              return ListTile(
                title: Text(
                  item,
                  style: _itemFont,
                ),
              );
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