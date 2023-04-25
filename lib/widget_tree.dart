import 'package:bucketlist/auth.dart';
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

  void loadGlobalAsist(DocumentSnapshot doc)
  {
    Map data = doc.data() as Map;
    if (data["host"] == 2)
    {
      globals.UID = globals.UID = data["partner"];
      globals.host = 2;
      db.collection("users").doc(data["partner"]).get().then((DocumentSnapshot doc) => {
        loadGlobalAsist2(doc)
      });
    }
    if (data["host"] == 1)
    {
      globals.UID = globals.UID = user!.uid;
      globals.host = 1;
      loadGlobalAsist2(doc);
      
    }
    
  }

   loadGlobalAsist2(DocumentSnapshot<Object?> doc) {
      Map data = doc.data() as Map;
      globals.HerNinckName = data["HerNinckName"];
      globals.HisNinckName = data["HisNinckName"];

   }

  void loadGlobal() {
    if (globals.host == 0){
      
      db.collection("users").doc("${user?.uid}").get().then((DocumentSnapshot doc) => {
        loadGlobalAsist(doc),
        
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          loadGlobal();
          return NavigationPage();
        }else{
          return const LoginPage();
        }
      } ,
      );
  }
}


