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
    
    for (var entrie in data.entries ){
      if (entrie.key == "partner") globals.partnerUID = entrie.value;
      if (entrie.key == "host") globals.host = entrie.value;
     
    }
    
    if (globals.host == 2) {
      globals.UID = globals.partnerUID;
    }
    else{
      globals.UID = user!.uid;
    }

  }

  Future<void> loadGlobal()async {
    if (globals.host == 0){
      
      await db.collection("users").doc("${user?.uid}").get().then((DocumentSnapshot doc) => {
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
