import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/shared/constants.dart';
import 'package:flutter_firebase/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({ required this.toggleView });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Variables used to save the various registration details
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  
  String error = '';
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],

      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Register page'),
        actions: <Widget>[
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
            ),
            icon: Icon(Icons.keyboard_arrow_right),
            label: Text('Continue as guest'),
            onPressed: () async {
              setState(() => loading = true);
              dynamic result = await _auth.signInAnon();
              if (result == null){
                setState(() {
                  error = 'An error happened, try again!';
                  loading = false;
                });
              }
            },
          ),
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.black), // Couleur du texte et de l'icône
            ),
            icon: Icon(Icons.person),
            label: Text('Sign in'),
            onPressed: () async {
              widget.toggleView();
            },
          )
        ]
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              // First name part
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'First name'),
                validator: (val) => val!.isEmpty ? 'Enter your first name' : null,
                onChanged: (val) {
                  setState(() => firstName = val);
                }
              ),
              SizedBox(height: 20.0),
              // Last name part
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Last name'),
                validator: (val) => val!.isEmpty ? 'Enter your last name' : null,
                onChanged: (val) {
                  setState(() => lastName = val);
                }
              ),
              SizedBox(height: 20.0),
              // Email part
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
              // Password part
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                }
              ),
              SizedBox(height: 20.0),
              // Button for validate
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[400],
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(firstName, lastName, email, password);
                    if (result == null){
                      setState(() {
                        error = 'Please supply a valid email';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ]
          ),
        ),
      ),
    );
  }
}