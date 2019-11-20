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

//Class that stores a Grocery Store and its information
  class GroceryStores {
    var name = "";
    var address = "";
    var filename = "";

    int width = 0;
    int height = 0;

    var selected = true;

    GroceryStores(
      this.name, this.address, this.filename, this.width, this.height
      );
  }

  //Checks if the address is currently selected
  bool check(int index, List<GroceryStores> list) {
    return list[index].selected;
  }
  //Grabs the current Grocery store's name
  String namecheck(int index, List<GroceryStores> list) {
    return list[index].name;
  }
  //Grabs the current Grocery store's name
  String filecheck(int index, List<GroceryStores> list) {
    return list[index].filename;
  }
  //Grabs the current Grocery store's address
  String addresscheck(int index, List<GroceryStores> list) {
    return list[index].address;
  }

  //Check to see if there are enough stores selected
  bool checkEnough(List<GroceryStores> list) {
    int count = 0;
    for (int i=0; i<list.length; i++) {
      if (list[i].selected)
        count++;
    }
    return(count>=2);
  }

  //Dialog to alert if not enough stores are selected
  Future alertForStores(BuildContext context) {
    return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select at least two stores to compare prices.'),
        content: const Text('This feature is intended for when there are more than two stores.'),
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
  GroceryStores _walmart = 
   new GroceryStores("Walmart", "2044 Forest Ave.", "walmart.png", 125, 115);
  GroceryStores _safeway =
   new GroceryStores("Safeway", "Chico Placeholder", "safeway.png", 125, 125);

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
            padding: EdgeInsets.only(top: 10),
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
              child: Text('Compare', style: TextStyle(color: Colors.white)),
              padding: EdgeInsets.only(left: 50, right: 50),
              shape: StadiumBorder(side: BorderSide(color: Colors.black)),
              color: checkEnough(_groceryStores) ? (Colors.green) : (Colors.grey),
              onPressed: () {
                if (checkEnough(_groceryStores)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Compare(
                            groceryStores: _groceryStores, auth: widget.auth)),
                  );
                }
                else {
                  alertForStores(context);
                }
              },
            )
          )
        ],
      ))
    );
  }
}

class Compare extends StatefulWidget {
  Compare({this.auth, this.groceryStores});
  final BaseAuth auth;
  final List<GroceryStores> groceryStores;

  @override
  CompareState createState() => CompareState();
}

class CompareState extends State<Compare> {
  //Firebase database reference
  final dbRef = FirebaseDatabase.instance.reference();
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[];
  //List to store items from Firebase side
  List<dynamic> items = [];
  //User's UID
  String uid = "";

  //Initialize the state with variables
  void initState() {
    initializeVars();
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Price Comparison",
          style: TextStyle(color: Colors.black),
          ),
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
        SizedBox(
          height: 220,
          child:
        ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.groceryStores.length,
              itemBuilder: (BuildContext context, int index) => Padding (
                padding: EdgeInsets.only(left: 20, right: 20),
                child: showShops(index),
              ),
            ) ), ]),
        )
    );
  }

/*
* This function returns a card with a specific format for each store
* and all is needed is the filename and dimensions for the image
*
*/
  Row showShops(int index) {
    //Initiliaze shop variables
        GroceryStores store = widget.groceryStores[index];
        String filename = store.filename;
        int width = store.width;
        int height = store.height;
        int price = 200;
        return
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(children: <Widget>[
            Card( 
            elevation: 2,
            child: InkWell(
            onTap: () {},
            child: ClipPath(
            child: Container(
            child: Column(children: <Widget>[
              new Image.asset(
              'assets/$filename',
              width: width.toDouble(),
              height: height.toDouble(),
              fit: BoxFit.fill,
              ),
              Padding(padding: EdgeInsets.only(top: 180-height.toDouble()),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Price: \$$price")
                ],
                )
            ],),
              height: 200,
              width: 125,
              decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.green, width: 5),
                )),
            ),
          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3))),
            ),
        ))])]);
  }
}