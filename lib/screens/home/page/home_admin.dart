import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/event.dart';
import 'package:flutter_firebase/screens/home/event/event_list.dart';
import 'package:flutter_firebase/screens/home/event/event_form.dart';
import 'package:flutter_firebase/screens/home/participant/user_management.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatelessWidget {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    void _showSettingsPanal(){
      showModalBottomSheet(context: context, builder: (context){
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: EventForm(),
          ),
        );
      });
    }

    return StreamProvider<List<Event>?>.value(
      value: DatabaseService().events,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],

        appBar: AppBar(
          title: Text('Admin'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            // Logout button
            TextButton.icon(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),

            // Gestion users button
            TextButton.icon(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              icon: Icon(Icons.settings),
              label: Text('Gestion users'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagement()), // Open User Management page
                );
              },
            )
          ]
        ),

        body: EventList(),

        floatingActionButton: FloatingActionButton(
          onPressed: () => _showSettingsPanal(),
          backgroundColor: Colors.brown[400],
          foregroundColor: Colors.white,
          child: Icon(Icons.add), // '+' icon inside the button
        ),
      ),
    );
  }
}