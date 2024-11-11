import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/user_m.dart';
import 'package:flutter_firebase/screens/home/page/home_admin.dart';
import 'package:flutter_firebase/screens/home/page/home_uknow.dart';
import 'package:flutter_firebase/screens/home/page/home_user.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:flutter_firebase/shared/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_m?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user?.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData? userData = snapshot.data;
          
          if(userData?.admin == null){
            print("Connexion en tant qu'Inconnue");
            return HomeUknow();
          } else {
            if((userData?.admin)!){
              print("Connexion en tant qu'Admin");
              return HomeAdmin();
            } else {
              print("Connexion en tant qu'Utilisateur");
              return HomeUser();
            }
          }
        } else {
          return Loading();
        }
      }
    );
  }
}