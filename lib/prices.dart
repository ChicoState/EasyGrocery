import 'package:flutter/material.dart';
import 'auth.dart';
import 'shoplist.dart';
//Firebase Database
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'dart:convert';


class Prices extends StatefulWidget {
  final BaseAuth auth;
  final List<String> groceryList; //grocery list passed from parent widget

  Prices({this.auth, this.callback, this.reset(), this.groceryList});
  final Function(Widget) callback;
  final VoidCallback reset;

  @override
  PricesState createState() => PricesState(this.groceryList);
}

//class to store response from price compare that is passed to compare
class PriceCompareReturn{
  double safewayCost=0.0;
  double walmartCost=0.0;
  var safewayList=[];
  var walmartList=[];
  PriceCompareReturn(this.safewayCost, this.safewayList, this.walmartCost, this.walmartList);
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
  //constructor to pass in grocerylist
  PricesState(this._groceryList);
  //Firebase database reference
  final dbRef = FirebaseDatabase.instance.reference();
  //list to contain all items in the users grocery list
  List<String> _groceryList;
  //List to store items from Firebase side
  List<dynamic> items = [];
  //User's UID
  String uid = "";
  //Grocery stores nearby
  List<GroceryStores> _groceryStores = <GroceryStores>[];
  
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
      decoration: BoxDecoration(color: check(index, _groceryStores) ? Colors.green: Colors.grey,
      border: Border.all(width: 1, color: Colors.black),
      ),
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
                Future<PriceCompareReturn> ret = priceCompare();
                ret.then( (value){
                  //Checks if enough stores were selected
                if (checkEnough(_groceryStores)) {
                  widget.callback(Compare(groceryStores: _groceryStores, data: value, auth: widget.auth, reset: (){
                    widget.reset();
                  },
                  ));
                }
                else { //Sends alert notifying that not enough stores were selected
                  alertForStores(context);
                }
                });
              },
            )
          ),
        ],
      ))
    );
  }

  String encodeListAsJson(){
    String jsonlist = "";
    int lastIndex = _groceryList.length-1;
    jsonlist += '['; //add opening brace
    for(String item in _groceryList){
      jsonlist += "{\"itemname\":\"";
      jsonlist += item;
      jsonlist += "\"}";
      if(item != _groceryList[lastIndex]){
        jsonlist +=", ";
      }
    }
    jsonlist += ']'; //add closing brace
    
    return jsonlist;
  }

  List<Items> generateItemList(var jsonitems){
    List<Items> items = [];
    for(var i = 0; i < jsonitems.length; i++){
      var part = jsonitems[i];
      items.add(Items(part['name'], part['cost'] ));
    }
    return items;
  }

  Future<PriceCompareReturn> priceCompare() async{
    Map<String, String> headers = {"Content-type": "application/json"};
    var url = 'http://34.222.160.242:3000/Easygrocery/api/compare';
    var jsonText = encodeListAsJson();
    var response = await post(url, headers: headers, body: jsonText);
    var resp = jsonDecode(response.body);
    //handle safeway
    var safeway = resp[0];
    var sCost = safeway['cost'];
    //generate list of items from safeway
    var sList = generateItemList(safeway['items']);
    //var sUnk = safeway['unknown'];
    //handle walmart
    var walmart = resp[1];
    var wCost = walmart['cost'];
    //generate list of items from walmart
    var wList = generateItemList(walmart['items']);
    //var wUnk = walmart['unknown'];

    PriceCompareReturn ret = PriceCompareReturn(sCost, sList, wCost, wList);
    return ret;
  }

}

class Compare extends StatefulWidget {
  Compare({this.auth, this.groceryStores, this.data, this.reset()});
  final BaseAuth auth;
  final List<GroceryStores> groceryStores;
  final PriceCompareReturn data;
  final VoidCallback reset;

  @override
  CompareState createState() => CompareState(data);
}

class CompareState extends State<Compare> {
  CompareState(this.data);
  //Firebase database reference
  final dbRef = FirebaseDatabase.instance.reference();
  //list to contain all items in the users grocery list
  List<String> _groceryList = <String>[];
  //List to store items from Firebase side
  List<dynamic> items = [];
  //User's UID
  String uid = "";
  //container that hold the data to be displayed
  PriceCompareReturn data;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        child: Column(children: <Widget>[
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
        SizedBox(
          height: 220,
          child:
      //Builds shop cards with their pictures and total cost for 
      //each store
        ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.groceryStores.length,
              itemBuilder: (BuildContext context, int index) => Padding (
                padding: EdgeInsets.only(left: 20, right: 20),
                
                child: showShops(index, (index==0) ? data.walmartCost : data.safewayCost, (index==0) ? data.walmartList : data.safewayList ),
              ),
            ) ), ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left:8, right: 8),),
                Expanded( child:Text("Click on one of the stores to show your shopping list!" +
                " Click the button below to reselect the stores you've chosen."))
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              MaterialButton(
                child: Text('Reset Selection', style: TextStyle(fontSize: 14),),
                color: Colors.green,
                textColor: Colors.white,
                shape: StadiumBorder(side: BorderSide(color: Colors.black)),
                padding: EdgeInsets.only(left: 50, right: 50),
                onPressed: () {
                  widget.reset();
                  },
            )
          ],),
          //Adds a row with text to instruct user
            ]
            )
        ),
        //Adds Navigation bar to the bottom of the app screen
    );
  }

/*
* This function returns a card with a specific format for each store
* and all is needed is the filename and dimensions for the image
*
*/
  Row showShops(int index, double price, List<Items> list) {
    //Initiliaze shop variables
        GroceryStores store = widget.groceryStores[index];
        String filename = store.filename;
        int width = store.width;
        int height = store.height;
        return
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(children: <Widget>[
            Card( 
            elevation: 2,
            child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Shoplist(
                        store: store, list: list, auth: widget.auth)),
              );
            },
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