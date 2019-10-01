import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'main.dart';
import 'login.dart';
import 'register.dart';


class GroceryListState extends State<GroceryList> {
  //variables for this class
  String _itemToAdd;
  List<String> _groceryList = <String>[];
  final TextStyle _itemFont = const TextStyle(fontSize: 18.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //text controller used to clear text form
  final TextEditingController _textController = new TextEditingController();

  //override the build function
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Text('My Grocery List'),
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          title: TextStyle(
              color: Colors.greenAccent, fontSize: 25.0, fontFamily: 'roboto')
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: _addMenu,
          )
        ],
      ),
      body: _buildGroceryList(),
      bottomNavigationBar: BottomAppBar (
        //color: Colors.greenAccent,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child:
            IconButton(icon: Icon(Icons.local_grocery_store),  iconSize: 30, onPressed: (){
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
    );
  }

  //function to build grocery list from _groceryList variable
  Widget _buildGroceryList() {
    return ListView.separated(
        //add seperators between each row
        separatorBuilder: (context, i) => Divider(
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(16.0),
        //number of items is the size of our list
        itemCount: _groceryList.length,
        itemBuilder: (context, i) {
          //build each individual row
          return _buildRow(_groceryList[i]);
        });
  }

  //function to build each individual row of grocery list
  Widget _buildRow(String item) {
    return ListTile(
        title: Text(
          item,
          style: _itemFont,
        ),
        trailing: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onTap: () {
          setState(() {
            _groceryList.remove(item);
          });
        });
  }

  void _addMenu() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
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
                        validator: (input) {
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
    print("Adding");
    if (_itemToAdd != "") {
      _groceryList.add(_itemToAdd);
    }
    _textController.clear();
    _itemToAdd = "";
  }
} //GroceryListState

class GroceryList extends StatefulWidget {
  @override
  GroceryListState createState() => GroceryListState();
}