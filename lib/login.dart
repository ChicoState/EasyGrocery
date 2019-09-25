 
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

  //Store values into these variables upon entering them into field
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      //Added a form which will have a key to save input
      body: Form(
        key: _formKey, //Formkey to save input
        //Formats input fields in a container with a padding to clean it up
        child: new Container(
           padding: new EdgeInsets.all(25.0), 
        //Added a column in the center of the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Added textboxes with an icon
            TextFormField(
              decoration: InputDecoration(icon: Icon(Icons.email), helperText: "Email"),
              validator: (input){
                if (input.isEmpty) {
                  return "Please enter an Email.";
                }
              },
              onSaved: (input) => _password = input,
            ),
            TextFormField(
              decoration: InputDecoration(icon: Icon(Icons.lock), helperText: "Password"),
              validator: (input){
                if (input.length < 6) {
                  return "Please enter a Password at least 6 characters.";
                }
              },
              onSaved: (input) => _email = input,
              obscureText: true,
              ),
              //Added a submit button that goes to the next page upon press
              RaisedButton(
                onPressed: login,
                //Labels the button with Submit
                child: Text('Submit'),
                )
          ],
        ),
      ),),
    );
  }
  void login()
  {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      //Firebase stuff
      Navigator.push(context,
      new MaterialPageRoute(builder: (context) => MyHomePage(title: 'EasyGrocery')),
      );
    }
  }
}
