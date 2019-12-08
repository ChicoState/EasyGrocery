import 'package:flutter/material.dart';
import 'auth.dart';
import 'prices.dart';
//Firebase Database
import 'package:firebase_database/firebase_database.dart';

class Shoplist extends StatefulWidget {
  Shoplist({this.auth, this.list, this.store});
  final BaseAuth auth;
  //Pass by clicked on Store
  final GroceryStores store;
  final List<Items> list;

  @override
  ShoplistState createState() => ShoplistState(list);
}

//Class that stores a item and its information
  class Items {
    var name = "";
    var price = 0.0;
    var selected = false;

    Items(
      this.name, this.price
      );
  }

class ShoplistState extends State<Shoplist> {
  ShoplistState(this.itemlist);
  //Firebase database reference
  final dbRef = FirebaseDatabase.instance.reference();
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[];
  //List to store items from Firebase side
  List<dynamic> items = [];
  //User's UID
  String uid = "";

  List<Items> itemlist;

  //Temporary list of static items with their prices
  /*
  List<Items> itemlist = [
    Items("Nesquick Chocolate Milk", 2.50),
    Items("Cheez-it, family size", 5.25),
    Items("Dozen Eggs", 3.99),
    Items("Sourdough bread", 6.99),
  ];
  */

  //Calls this to initialize the Firebase variables with user list
  void initState() {
    initializeVars();
    super.initState();
  }

  Future expireDateNotify(BuildContext context) {
    return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter an expiration date so we can remind you'),
        content: const TextField(
            decoration: InputDecoration(
              labelText: 'Enter date: (ex: 04-10-2019)',
            )
          ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.black),
              ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }


  //Card for each item in the groceryList
  Card makeItem(int index) {
    var itemName = itemlist[index].name;
    var price = itemlist[index].price;
    return Card(
    elevation: 8,
    margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Container(
      decoration: BoxDecoration(color: itemlist[index].selected ? Colors.green: Colors.grey),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0, top: 8),
          decoration: new BoxDecoration(
            border: new Border(
              right: new BorderSide(width: 1, color: itemlist[index].selected ? Colors.green: Colors.grey))),
              child: Icon(itemlist[index].selected ? (Icons.check_box) :(Icons.check_box_outline_blank), color: Colors.white,),
            ),
            title: Text(
              itemName,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(children: <Widget>[
              Icon(Icons.attach_money, color: Colors.white),
              Text(" " + price.toStringAsFixed(2), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ],),
            trailing: new Column(children: <Widget>[
              new Container(
                child: new IconButton(
                  icon: Icon(Icons.date_range, 
                  color: itemlist[index].selected ? Colors.white: Colors.grey),
                  onPressed: (){
                    //Run notifcation button
                    if (itemlist[index].selected)
                      expireDateNotify(context);
                  },)
              )
            ],
            ),
            /*itemlist[index].selected ? 
              Icon(Icons.date_range, color: Colors.white):
              Icon(Icons.date_range, color: Colors.grey),*/
              onTap: (){
                setState(() {
                  itemlist[index].selected = !itemlist[index].selected;
                });
              },
      ),
    ),
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
  @override
//Create widget that will contain a shopping list
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Your Grocery List",
          style: TextStyle(color: Colors.black),
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: itemlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeItem(index);
              },
            ) 
          ),
          ]
        )
      )
    );
  }
}