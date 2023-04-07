import 'package:bucketlist/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final User? user = Auth().correntUser;

  Future<void> signOut() async {
    await Auth().signOut();

  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  
  Future<void> addata() async{
    print(globals.partnerUID);
    db.collection("users").doc("${user?.uid}").get().
      then((DocumentSnapshot test)  async => {
        if (!test.exists){
          await db.collection("users").doc("${user?.uid}").set({"partner" : "CZ7rQXX5vHaGe0eFPEQfrq3uXGp1", "token" : 1, "host" : 1}),    // guest= 0(idk) 1(host) 2(guest) 
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "BucketList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "HostWishList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "GuestWishList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "DoneList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "IdeasList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "LaterList"}),
          await db.collection("users").doc("${user?.uid}").collection("savedDecks").add({"name" : "DislikeList"}),
          
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



