import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:flutter_firebase/models/user_m.dart';
import 'package:provider/provider.dart';

class UserManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_m?>(context);

    return StreamProvider<List<UserData>?>.value(
      value: DatabaseService(uid: user?.uid).listUser, // Assume that 'DatabaseService' has a stream of users
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestion des utilisateurs'),
          backgroundColor: Colors.brown[400],
        ),
        body: UserList(),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>?>(context);

    if (users == null) {
      return Center(child: CircularProgressIndicator());
    }

    List<UserData> usersNoAdmin = [];
    for(UserData user in users){
      if(!(user.admin!)){
        usersNoAdmin.add(user);
      }
    }
    if (usersNoAdmin.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: usersNoAdmin.length,
      itemBuilder: (context, index) {
        return UserTile(user: usersNoAdmin[index]);
      },
    );
  }
}

class UserTile extends StatelessWidget {
  final UserData user;
  UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.0),  // Adds space around the border
      padding: EdgeInsets.all(2.0), // Adds space inside the border
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,     // Color of the border
          width: 1.0,               // Thickness of the border
        ),
        borderRadius: BorderRadius.circular(8.0), // Rounded corners (optional)
      ),
      
      child: ListTile(
        title: Text(
          (user.firstName == null || user.lastName == null)
              ? 'Unknown User'
              : (user.firstName! + ' ' + user.lastName!),
          style: TextStyle(fontWeight: FontWeight.bold), // Bold text
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton.icon(
              label: Text(
                'Upgrade to Admin',
                style: TextStyle(color: Colors.black),
              ),
              icon: Icon(Icons.admin_panel_settings, color: Colors.black),
              onPressed: () {
                // Promote the user to admin logic here
                DatabaseService().promoteToAdmin(user.uid!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
