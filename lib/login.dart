  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/rendering.dart';
  import 'main.dart';
  import 'home_page.dart';
  import 'auth.dart';
  import 'register.dart';

  class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title, this.onSignedIn, this.auth}) : super(key: key);
  //const MyLoginPage({Key key, this.title, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
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
        // Here we take the value from the MyLoginPage object that was created by
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
//           padding: new EdgeInsets.only(left:25.0), 
           padding: new EdgeInsets.all(25.0), 
        //Added a column in the center of the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Added textboxes with an icon
            TextFormField(
              decoration: new InputDecoration(
                icon: Icon(Icons.email, color: Colors.black), 
                helperText: "Email", 
                focusedBorder:UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
                ),
              cursorColor: Colors.black,
              
              validator: (input){
                //Valid email contains an "@" character
                if (!input.contains('@')) {
                  return "Please enter a valid Email.";
                }
              },
              onSaved: (input) => _email = input,
            ),
            TextFormField(
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
                  return "Please enter of a Password at least 6 characters.";
                }
              },
              onSaved: (input) => _password = input,
              obscureText: true,
              ),
              //Added a submit button that goes to the next page upon press
              //and authenticates email and password
              MaterialButton(
                //Login button with styling
                onPressed: login,
                elevation: 5,
                minWidth: 200,
                color: Colors.greenAccent,
                //Labels the button with Submit
                child: Text('Submit'),
                ),
                MaterialButton(
                  //Register button with styling
                  onPressed: register,
                child: Text('Create an account'),
                ),
          ],
        ),
      ),),
    );
  }
  Future<void> login() async
  {
    final formState = _formKey.currentState;
    //Validates the textfields with the validators that we had specified.
    //It will be under the textformfield called validator, we will need
    //to add more.
    //Tries to sign into a Firebase account with the given information
    if (formState.validate()) {
      //Firebase stuff
      formState.save();
      try {
      //final BaseAuth auth = AuthProvider.of(context).auth;
      final String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
      print('Signed in: $userId');
      //Navigator.push(context,
      //new MaterialPageRoute(builder: (context) => MyHomePage(title: 'EasyGrocery')),
      //);
      widget.onSignedIn();
      } catch (e) {
        print(e.message);
      }
    }
  }
  void register() {
    Navigator.push(context,
    new MaterialPageRoute(builder: (context) => MyRegisterPage(title: 'EasyGrocery')),
    );
  }
}
