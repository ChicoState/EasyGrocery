import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:convert';


//Class to represent search menu to add items to grocery list
class SearchList extends StatefulWidget {
  SearchList({Key key, this.groceryList, this.addCallback}) : super(key: key);
  
  final List<String> groceryList; //grocery list passed from parent widget

  //callback function passed by parent to update grocery list
  final void Function(String item) addCallback;
  
  @override
  SearchListState createState() => SearchListState();
}

class SearchListState extends State<SearchList> {
  //variables for this class
  String _searchString = "";
  //Text styling for list tiles
  final TextStyle _itemFont = const TextStyle(fontSize: 18.0);
  //text controller used to clear text form
  final TextEditingController _textController = new TextEditingController();
  //List to hold all items in search menu
  List<String> _searchList = new List<String>();
  

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                //clear search list when text field is tapped
                _searchList.clear();
              },
              onChanged: (value) {
                _searchString = value;
              },
              controller: _textController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            )),
        //Search button
        MaterialButton(
          onPressed: () {
            FocusScope.of(context).previousFocus(); //dismiss keyboard
            _search();
          },
          elevation: 5,
          minWidth: 200,
          color: Colors.greenAccent,
          //Labels the button with search
          child: Text('Search'),
        ),
        //List of items to add
        Expanded(
          child: _buildSearchList(),
        ),
      ]),
    );
  } // build 

  /// search function
  /// for now just adds item to search list
  /// later with grab items from database
  void _search() {
    setState(() {
      //clear current search list
      _searchList = new List<String>();
      //add search string to top of list
      if (_searchString != "") {
        _searchList.insert(0, _searchString);
      }
      //get database response and add values to the search list
      _addRequest(_searchString);
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
        icon: Icon(widget.groceryList.contains(item) ? (Icons.check_circle) :(Icons.add)),
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
        _textController.clear();
        _searchString = "";
        //no duplicate items in list
        if(! widget.groceryList.contains(itemName)){
          _searchList = List.from(_searchList);
          widget.addCallback(itemName); //callback to parent to update parent grocery list
        }
      });
  }

  /*
  Requests all items from the products database
  that match the argument itemName
  Then adds those items to the search list
  */
  void _addRequest(String itemName) async{
    try{
      print("Sending");
      var url = 'http://34.222.160.242:3000/Easygrocery/api/item/?item=' + itemName;
      var response = await get(url);
      var resp = json.decode(response.body); //decode json response
      //resp is a list of hashmaps<string, dynamic>
      for(var i = 0; i < resp.length; i++){
        _searchList.add( resp[i]['productName'].toString());
      }
    }
    catch(exception){
      print("An error occurred");
    }
    finally{
      setState(() {
        //do nothing
      });
    }
  }
}
