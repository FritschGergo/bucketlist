import 'package:bucketlist/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;
import 'add_partner.dart';
import 'erarnToken.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;

  Future<void> signOut() async {
    globals.host = 0;           
    globals.inprogress = false;
    globals.GuestUID = "";
    globals.UID = "";
    globals.HisNinckName = "";
    globals.HerNinckName = "";
    globals.currentDeck = {};
    globals.UsersCards = [];
    globals.GlobalCards = [];
    globals.ownedDeck = [];
    globals.newDeck = [];
    globals.currentCardID = "";
    globals.token = 0;
    globals.language = "english";
    globals.languageMap = {};
    Auth().signOut();


  }
   Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut,
     child: const Text('Sign Out'));
      
  }

  Widget _CopyUidButton(){
    return ElevatedButton(onPressed: copyUid,
     child: const Text('Copy UID'));
      
  }

  Future<void> copyUid() async {
    await Clipboard.setData(ClipboardData(text: user!.uid));
    
  }

   Widget ErnTokenbButton(BuildContext context){
    return ElevatedButton(
      onPressed: () {
                Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  earnToken()),
                            );
              },
      child: const Text('Earn token'));
      
  }

   Widget tokenDisplay() {
    return Text("You have ${globals.token} token");
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
              tokenDisplay(),
              _signOutButton(),
              ElevatedButton(onPressed:  () { Navigator.of(context).
                  push( MaterialPageRoute(builder: (context) => add_partner()));
                      },
                     child: const Text('Add')),
              _CopyUidButton(),
              ErnTokenbButton(context),
              //nyelv választó
      
    
  
            ],
          )
          ,)

    );

  }
 

}



