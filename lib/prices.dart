import 'package:flutter/material.dart';
import 'auth.dart';
//Firebase Database
import 'package:firebase_database/firebase_database.dart';

class Prices extends StatefulWidget {
  Prices({this.auth});
  final BaseAuth auth;

  @override
  PricesState createState() => PricesState();
}

  class GroceryStores {
    var name = "";
    var address = "";
    var selected = true;

    GroceryStores(this.name, this.address);
  }

  //Checks if the address is currently selected
  bool check(int index, List<GroceryStores> list) {
    return list[index].selected;
  }
  //Grabs the current Grocery store's name
  String namecheck(int index, List<GroceryStores> list) {
    return list[index].name;
  }
  //Grabs the current Grocery store's address
  String addresscheck(int index, List<GroceryStores> list) {
    return list[index].address;
  }

class PricesState extends State<Prices> {
  //Firebase database reference
  final dbRef = FirebaseDatabase.instance.reference();
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[];
  //List to store items from Firebase side
  List<dynamic> items = [];
  //User's UID
  String uid = "";
  //Grocery stores nearby
  List<GroceryStores> _groceryStores = <GroceryStores> [
  ];

  //Create static locations for now
  GroceryStores _walmart = new GroceryStores("Walmart", "2044 Forest Ave.");
  GroceryStores _safeway = new GroceryStores("Safeway", "Chico Placeholder");

  //Calls this to initialize the above two variables
  void initState() {
    initializeVars();
    super.initState();
    _groceryStores.add(_walmart);
    _groceryStores.add(_safeway);
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

  //A card that holds the design of the Grocery store style for the user to
  //click on and enable which locations they wanna look at
  Card makeTile(int index) => Card(
    elevation: 8,
    margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: InkWell(
    onTap: () {
      setState(() {
        _groceryStores[index].selected = !_groceryStores[index].selected;
      });
    },
    child: Container(
      decoration: BoxDecoration(color: check(index, _groceryStores) ? Colors.green: Colors.grey),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
            border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.green))),
              child: Icon(Icons.local_grocery_store, color: Colors.white),
            ),
            title: Text(
              namecheck(index, _groceryStores),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(children: <Widget>[
              Icon(Icons.explore, color: Colors.yellowAccent),
              Text(" " + addresscheck(index, _groceryStores) + "\n - 5 miles away", style: TextStyle(color: Colors.white))
            ],),
            trailing: Icon(check(index, _groceryStores) ? (Icons.check_box) :(Icons.check_box_outline_blank), color: Colors.white,),
      ),
    ),
  ));

  //override the build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column (
        children: <Widget>[
          new Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _groceryStores.length,
              itemBuilder: (BuildContext context, int index) {
                return makeTile(index);
              },
            ) 
          ),
          Container(
            child: MaterialButton(
              child: Text('Compare'),
              padding: EdgeInsets.only(left: 50, right: 50),
              shape: StadiumBorder(),
              color: Colors.greenAccent,
              onPressed: () {},
            )
          )
        ],
      ))
    );
  }
}