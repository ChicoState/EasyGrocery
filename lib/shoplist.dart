import 'package:flutter/material.dart';
import 'auth.dart';
import 'prices.dart';
//Firebase Database
import 'package:firebase_database/firebase_database.dart';

class Shoplist extends StatefulWidget {
  Shoplist({this.auth, this.store});
  final BaseAuth auth;
  //Pass by clicked on Store
  final GroceryStores store;

  @override
  ShoplistState createState() => ShoplistState();
}

class ShoplistState extends State<Shoplist> {
  //Firebase database reference
  final dbRef = FirebaseDatabase.instance.reference();
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[];
  //List to store items from Firebase side
  List<dynamic> items = [];
  //User's UID
  String uid = "";

  //Temporary list of static items with their prices
  var itemList = {
    "Nesquick Chocolate Milk": 2.50,
    "Cheez-it, family size": 5.25,
    "Dozen Eggs": 3.99,
    "Sourdough bread": 6.99,
  };

  //Calls this to initialize the Firebase variables with user list
  void initState() {
    initializeVars();
    super.initState();
  }

  //Card for each item in the groceryList
  Card makeTile(int index) {
    bool toggle = true;
    var keys = itemList.keys.toList();
    var itemName = keys[index];
    return Card(
    elevation: 8,
    margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: InkWell(
    onTap: () {
    },
    child: Container(
      decoration: BoxDecoration(color: toggle ? Colors.green: Colors.grey),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
            border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.green))),
              child: Icon(toggle ? (Icons.check_box) :(Icons.check_box_outline_blank), color: Colors.white,),
            ),
            title: Text(
              itemName,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(children: <Widget>[
              Icon(Icons.attach_money, color: Colors.white),
              Text(" \$" + itemList[itemName].toString(), style: TextStyle(color: Colors.white))
            ],),
            trailing: Icon(Icons.date_range, color: Colors.white),
      ),
    ),
  ));
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
  @override
//Create widget that will contain a shopping list
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeTile(index);
              },
            ) 
          ),
          ]
        )
      )
    );
  }
}