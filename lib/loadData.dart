

import 'package:bucketlist/widget_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import '../globals.dart' as globals;
import 'auth.dart';

class LoadMyData{ 
  final User? user = Auth().correntUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  

  void loadGlobals()  { 
    {
      if (globals.host == 0 ){
        db.collection("users").doc(user?.uid).get().then((DocumentSnapshot doc) => {
          loadGlobalAsist(doc),
        });
      }
    }
  }

  Future<void> loadGlobalCards()async {
    await db.collection("cards").where("toList" ,isEqualTo: true).get()
        .then((QuerySnapshot qs) => {loadGlobalCardsAssist(qs)} );
  }

   loadGlobalCardsAssist(QuerySnapshot<Object?> qs) {

    List<Map<String, dynamic>> MyDtaList = []; 
     for (var data in qs.docs)
     {
      Map<String, dynamic> i = data.data() as Map<String, dynamic>;
      i["id"] = data.id;
      MyDtaList.add(i);

     }
     globals.GlobalCards = MyDtaList;
    }

  /*Future<void> loadCards()
  async {
   await db.collection("users").doc(globals.UID).collection("savedCards").where("toList" ,isEqualTo: true).get()
        .then((QuerySnapshot qs) => {loadCardsAssist(qs)} );
  }
    
  loadCardsAssist(QuerySnapshot<Object?> qs) {
     List<Map<String, dynamic>> MyDtaList = []; 
     for (var data in qs.docs)
     {
      Map<String, dynamic> i = data.data() as Map<String, dynamic>;
      i["id"] = data.id;
      MyDtaList.add(i);

     }
     globals.UsersCards = MyDtaList;
    }
  */
  void loadGlobalAsist(DocumentSnapshot doc) async 
  {
    if (doc.exists)
    {
        Map data = doc.data() as Map;
        
        if (data["host"] == 2)
        {
          globals.UID = data["partner"];
          globals.host = 2;
          db.collection("users").doc(data["partner"]).get().then((DocumentSnapshot doc2) => {
            loadGlobalAsist2(doc2)
          
          });
          globals.token = data["token"];
          globals.lastIdea = data["lastIdea"].toDate();
          globals.bannedFromIdeas = data["bannedFromIdeas"];

        }

        if (data["host"] == 1)
        {
          globals.UID = user!.uid;
          globals.host = 1;
          loadGlobalAsist2(doc);
          globals.token = data["token"];
          globals.lastIdea = data["lastIdea"].toDate(); 
          globals.bannedFromIdeas = data["bannedFromIdeas"];
        }

        if (data["host"] == 3) 
        {
          globals.host = 3;
          globals.UID = user!.uid;
          loadLanguage("english");
        }

        
        openListenerCard();
          loadGlobalCards().then((value) => {
            
            globals.inprogress = false,
            openListenerUser(),
          
          });
        
    }else
    { 
      globals.UID = user!.uid;
       await db.collection("users").doc(user?.uid).set({
                    "host" : 3,                // guest= 0(idk) 1(host) 2(guest) 3(ready to pair)
                    }).then((value) => loadGlobals());
      loadLanguage(globals.language);
      print("no data");

    }
    
  }

  loadGlobalAsist2(DocumentSnapshot<Object?> doc) {

      
  
      Map data2 = doc.data() as Map;
      
      //globals.HerNinckName = data2["HerNinckName"];
      //globals.HisNinckName = data2["HisNinckName"];
      globals.language = data2["language"];
      globals.dailyDeckCompleted = data2["dailyDeckCompleted"];
                         // addpartner
      loadLanguage(globals.language);
      allLanguageLoad();
      loadDate(data2["previusDate"].toDate());

  }
  
  Future<void> loadLanguage(String language) async {
    await db.collection("languages").where("language" ,isEqualTo: language).get()
        .then((QuerySnapshot qs) => {loadLanguageAssist(qs)} );
  }
  
  loadLanguageAssist(QuerySnapshot<Object?> qs) {
    var i = qs.docs.first.data() as Map<String, dynamic>;
    globals.languageMap = i["languageMap"] as  Map<String, dynamic>;
  }

  Future<void> allLanguageLoad() async {
    await db.collection("languages").where("toList" ,isEqualTo: true).get()
        .then((QuerySnapshot qs) => {allLanguageLoadAssist(qs)} );
  }

  void allLanguageLoadAssist(QuerySnapshot<Object?> qs){
    for (var i in qs.docs)
    {
      var data =i.data() as Map;
      globals.allLanguage.add(data["language"].toString());

    }
  }
  
  Future<void> loadDate(DateTime previousNtpTime) async {
    if (globals.dailyDeckCompleted){
      DateTime ntpTime = await NTP.now();
     //print(ntpTime);
     //print(previousNtpTime);

    if(previousNtpTime.year < ntpTime.year ||
       previousNtpTime.month < ntpTime.month ||
       previousNtpTime.day < ntpTime.day )
      {
        //globals.dailyDeckCompleted = false;
                
        await db.collection("users").doc(globals.UID).update(
              {"previusDate"       : ntpTime,
               "dailyDeckCompleted": false});
      }
    }  
  }

  
  void openListenerCard(){
    db.collection("users").doc(globals.UID).collection("savedCards").snapshots().listen((event) {
    for (var change in event.docChanges) {
      Map<String, dynamic> i  = change.doc.data() as Map<String, dynamic>;
      i["id"] = change.doc.id;
      switch (change.type) {
        
        case DocumentChangeType.added:
          bool added = false;
          for(int j = 0; j < globals.UsersCards.length; j++) // benne mararadt egy bug ki kell javítani a listener duplán érzékeli a hozzá adást!!
          {
            if(globals.UsersCards[j]["id"] == i["id"])
            {
              added = true;
              break;
            }
          }
          if(!added)
          {
            globals.UsersCards.add(i);
          }
          break;
        case DocumentChangeType.modified:
          for(int j = 0; j < globals.UsersCards.length; j++)
          {
            if(globals.UsersCards[j]["id"] == i["id"])
            {
              globals.UsersCards[j] = i;
              break;
            }
          }
          break;
        case DocumentChangeType.removed:
          for(int j = 0; j < globals.UsersCards.length; j++)
          {
            if(globals.UsersCards[j]["id"] == i["id"])
            {
              globals.UsersCards.removeAt(j);
              break;
            }
          }
          break;
      }
    }
  }
  
  );
  
  }

  
  void openListenerUser(){
    db.collection("users").doc(globals.UID).snapshots().listen((event) {
      var data = event.data();
      globals.HerNinckName = data!["HerNinckName"];
      globals.HisNinckName = data["HisNinckName"];
      globals.dailyDeckCompleted = data["dailyDeckCompleted"];
      globals.lastIdea = data["previusDate"].toDate();
    
    }
    );
  }

}

