import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/user_m.dart';
import 'package:flutter_firebase/screens/authenticate/authenticate.dart';
import 'package:flutter_firebase/screens/home/page/home.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_m?>(context);
    
    if(user==null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}