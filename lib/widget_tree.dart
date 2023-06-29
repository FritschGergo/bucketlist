import 'package:bucketlist/auth.dart';
import 'package:bucketlist/loadData.dart';
import 'package:bucketlist/pages/navigaton_page.dart';
import 'package:bucketlist/pages/login_register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();

   
}
FirebaseFirestore db = FirebaseFirestore.instance;
final User? user = Auth().correntUser;

class _WidgetTreeState extends State<WidgetTree>{

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return NavigationPage();
        }else{
          return const LoginPage();
        }
      } ,
      );
  }
}


