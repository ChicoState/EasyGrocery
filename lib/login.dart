 
  import 'package:flutter/material.dart';
  import 'main.dart';
  class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  void submit(){
    print("sup");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(widget.title),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.greenAccent, fontSize: 25.0, fontFamily: 'roboto')
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        //Added a column in the center of the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Added textboxes with an icon
            TextField(
              decoration: InputDecoration(icon: Icon(Icons.email), helperText: "Email")
            ),
            TextField(
              decoration: InputDecoration(icon: Icon(Icons.lock), helperText: "Password"),
              ),
              //Added a submit button that goes to the next page upon press
              RaisedButton(
                onPressed: () {
                   Navigator.push(context,
                   new MaterialPageRoute(builder: (context) => MyHomePage(title: 'EasyGrocery')),
                    );
                },
                //Labels the button with Submit
                child: Text('Submit'),
                )
          ],
        ),
      ),
    );
  }
}
