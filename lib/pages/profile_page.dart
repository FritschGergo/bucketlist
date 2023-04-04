import 'package:bucketlist/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final User? user = Auth().correntUser;

  Future<void> signOut() async {
    await Auth().signOut();

  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  
  Future<void> addata() async{
  
    db.collection("users").doc("${user?.uid}").get().
      then((DocumentSnapshot test)  async => {
        if (!test.exists){
          await db.collection("users").doc("${user?.uid}").set({"partner" : "", "token" : 1}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "BucketList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "WishList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "Done"}),
        }
      }
      
    
      );
  
     

   //await db.collection("users").doc("0${user?.uid}").add({"partner " : "sanya", "token" : 1});
   // 0 is host 1 is guest


   // var valami = await db.collection("users").doc("${user?.uid}").collection("savedDecks")
   // .where("b",isEqualTo: true ).get();
      
    

  }
  

   Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut,
     child: const Text('Sign Out'));
      
    
  }

  Widget _AddButton(){
    return ElevatedButton(onPressed: addata,
     child: const Text('Add'));
      
    
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _userUid(),
              _signOutButton(),
              _AddButton(),
            ],
          )
          ,)

    );

  }

}



