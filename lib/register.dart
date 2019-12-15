  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/rendering.dart';
  import 'main.dart';
  import 'home_page.dart';
  import 'login.dart';
  import 'auth.dart';

  //Firebase Database
  import 'package:firebase_database/firebase_database.dart';


  class MyRegisterPage extends StatefulWidget {
  MyRegisterPage({Key key, this.title, this.auth, this.onSignedIn()}) : super(key: key);
  final BaseAuth auth;
  final String title;
  final VoidCallback onSignedIn;


  @override
  _MyRegisterPageState createState() => _MyRegisterPageState();
  
}

class _MyRegisterPageState extends State<MyRegisterPage> {

  //Store values into these variables upon entering them into field
  String _email, _password, _fname, _lname, _cpassword;

  final dbRef = FirebaseDatabase.instance.reference();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
          BackButton(color: Colors.black,
          ),
        //Removes automatic back button on page
        automaticallyImplyLeading: false,
        // Here we take the value from the MyRegisterPage object that was created by
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
            //First name textfield
            TextFormField(
              key: Key('fname'),
              decoration: new InputDecoration(
                icon: Icon(Icons.person_outline, color: Colors.black), 
                helperText: "First Name", 
                focusedBorder:UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
                ),
              cursorColor: Colors.black,
              
              validator: (input){
                if (input.isEmpty) {
                  return "Please enter your First Name.";
                }
              },
              onSaved: (input) => _fname = input,
            ),

            //Last name textfield
            TextFormField(
              key: Key('lname'),
              decoration: new InputDecoration(
                icon: Icon(Icons.person_outline, color: Colors.black), 
                helperText: "Last Name", 
                focusedBorder:UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
                ),
              cursorColor: Colors.black,
              
              validator: (input){
                if (input.isEmpty) {
                  return "Please enter your Last Name.";
                }
              },
              onSaved: (input) => _lname = input,
            ),

            //Email textfield
            TextFormField(
              key: Key('email'),
              decoration: new InputDecoration(
                icon: Icon(Icons.email, color: Colors.black), 
                helperText: "Email", 
                focusedBorder:UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
                ),
              cursorColor: Colors.black,
              
              validator: (input){
                if (!input.contains('@')) {
                  return "Please enter an Email.";
                }
              },
              onSaved: (input) => _email = input,
            ),

            //Password textfield
            TextFormField(
              key: Key('pass'),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.black), 
                helperText: "Password", 
                focusedBorder:UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
                ),
              cursorColor: Colors.black,
              validator: (input){
                if (input.length < 6) {
                  return "Please enter a Password of at least 6 characters.";
                }
              },
              onSaved: (input) => _password = input,
              obscureText: true,
              ),

            //Confirm Password textfield
            TextFormField(
              key: Key('confpass'),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.black), 
                helperText: "Confirm Password", 
                focusedBorder:UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
                ),
              cursorColor: Colors.black,
              validator: (input){
                if (input.length < 6) {
                  return "Please enter a Password of at least 6 characters.";
                }
                if (input!=_password) {
                  return "Passwords must be the same.";
                }
              },
              onSaved: (input) => _cpassword = input,
              obscureText: true,
              ),
              MaterialButton(
                key: Key('register'),
                //Login button with styling
                onPressed: register,
                elevation: 5,
                minWidth: 200,
                color: Colors.greenAccent,
                //Labels the button with Submit
                child: Text('Register'),
                ),
          ],
        ),
      ),),
    );
  }
  Future<void> register() async
  {
    final formState = _formKey.currentState;
    //Validates the textfields with the validators that we had specified.
    //It will be under the textformfield called validator, we will need
    //to add more.
    formState.save();
    if (formState.validate()) {
      //Firebase stuff
      //formState.save();
      //Tries to make a Firebase account with the given information
      try {
      //final BaseAuth auth = AuthProvider.of(context).auth;
      final String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
      
      //WIP
      //dbRef.child('$userId').set({
      //  'first name': _fname,
      //});
      widget.onSignedIn();
      Navigator.pop(context);
      //Navigator.push(context,
      //new MaterialPageRoute(builder: (context) => MyHomePage(title: 'EasyGrocery')),
      //);
      } catch (e) {
        print(e.message);
      }
    }
  }
}
