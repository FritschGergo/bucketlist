// ignore_for_file: unrelated_type_equality_checks

//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../globals.dart' as globals;

import '../auth.dart';
class review_page extends StatefulWidget {
  const review_page({super.key});

  @override
  State<review_page> createState() => _review_page();
  

}
 
class _review_page extends State<review_page> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;
  int _currentIndex = 0;
  int _previusReview = 0;
  var listener;
  
 
  void _incrementIndex(int review) {
    setState(() {
      _currentIndex = (_currentIndex + 1) % 20;
      _previusReview = review;
    });
  }

  void listenFirstcard(){    
    final collection = db.collection("users").doc(globals.UID).collection("InProgressDecks");
    listener = collection.snapshots().listen((event) {
      setState(() {});
    });
  } 

  Future<QuerySnapshot<Object?>> getdata() async {  
   QuerySnapshot cards = await db.collection("users").doc(globals.UID).collection("InProgressDecks")
    .where("list",isEqualTo: true).get();   
    return cards;
  }

  Future<void> setReview(String id, int review) async {
    if(globals.host == 2){ //guset
      await db.collection("users").doc(globals.UID)
            .collection("InProgressDecks").doc(id).update({"reviewGuest" : review});
    }
    else{ //host
      await db.collection("users").doc(globals.UID)
            .collection("InProgressDecks").doc(id).update({"reviewHost" : review});
    } 
  }

  Widget _currentCard() {
    //i = 0   no rewiwe
    //i = 1   like
    //i = 2   ok / maybe
    //i = 3   later
    //i = 4   dislike  
    return FutureBuilder(
      future: getdata(),
        builder: (context , snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.data!.docs.isEmpty == true) {
           listenFirstcard();
          return const CircularProgressIndicator();
        } 

        List<String> MyData = [];
          List<String> MyDataID = [];
          for (var docSnapshot in  snapshot.data!.docs){
               var data = docSnapshot.data() as Map;
               for (var i in data.entries)
               {
                if (i.key == "text") {
                  String str = i.value.toString().replaceAll("(her name)", globals.HerNinckName).replaceAll("(his name)", globals.HisNinckName);
                  MyData.add(str);
                  MyDataID.add(docSnapshot.id);
                }
               }
             }

        if(_currentIndex > 0){
           setReview(MyDataID[_currentIndex-1], _previusReview);
        }

        if(MyData.length <= _currentIndex && _currentIndex != 0)
        {
          copyReviewdCards();       
          listener?.cancel();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          },);
         
        }
        else{
        return Text(MyData[_currentIndex]);
        }

        return const Text("done");       
    
      }
    );
  }
  
    void copyReviewdCards(){  
      getdata().then((QSnapshot) => {copyReviewdCardsAsist2(QSnapshot)});
    }

    void copyReviewdCardsAsist2(QuerySnapshot QSnapshot)
    {
      int reviewHost = 0;
      int reviewGuest = 0;

      for (var docSnapshot in  QSnapshot.docs){
               var data = docSnapshot.data() as Map;
               for (var i in data.entries)
                {
                  if (i.key == "reviewGuest") reviewGuest = i.value;
                  if (i.key == "reviewHost") reviewHost = i.value;
                }

               if(reviewHost == 0 || reviewGuest == 0){
                  //wait for the second review
                }
                else if(reviewHost == 4 || reviewGuest == 4){
                  //delete card 
                  copyReviewdCardsAsist("DislikeList", docSnapshot.id , data);
                }
                else if(reviewHost == 3 || reviewGuest == 3){
                  //later deck
                  copyReviewdCardsAsist("LaterList", docSnapshot.id , data);
                }
                else if(reviewHost == 1 && reviewGuest == 1){
                  //Bucket List deck
                  copyReviewdCardsAsist("BucketList", docSnapshot.id , data);
                }
                else if(reviewHost == 2 && reviewGuest == 2){
                  //ideas card 
                  copyReviewdCardsAsist("IdeasList", docSnapshot.id , data);
                  
                }
                else if(reviewHost == 1 && reviewGuest == 2){
                  //Host Wishes deck
                  copyReviewdCardsAsist("HostWishList", docSnapshot.id , data);
                }
                else if(reviewHost == 2 && reviewGuest == 1){
                  //Host Guest deck
                  copyReviewdCardsAsist("GuestWishList", docSnapshot.id , data);
                }
             }

    }

   Future<void> copyReviewdCardsAsist(String deck, String id, Map data) async {
        QuerySnapshot mydata = await db.collection("users").doc(globals.UID).collection("savedDecks")
    .where("name",isEqualTo: deck).get();

        await db.collection("users").doc(globals.UID).collection("savedDecks").doc(mydata.docs.first.id)
            .collection("cards").doc(id).set(data as Map<String,dynamic>).then((value) async => {
              await db.collection("users").doc(globals.UID).collection("InProgressDecks").doc(id).delete()
            });
   }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Card(
              margin: EdgeInsets.all(50.0),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: _currentCard(),
                                      //style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
            
          SizedBox(
            height: 100.0,
            width: double.infinity,
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: _button0,
                    tooltip: 'Previous',
                    child: const Icon(Icons.favorite),
                  ),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: _button1,
                    tooltip: 'Next',
                    child: const Icon(Icons.thumb_up),
                  ),
                  FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: _button2,
                    tooltip: 'Button 1',
                    child: const Icon(Icons.watch_later),
                  ),
                  FloatingActionButton(
                    heroTag: "btn0",
                    onPressed: _button3,
                    tooltip: 'Button 2',
                    child: const Icon(Icons.thumb_down),
                  ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
  
  
  void _button0() {
    //_reviewCard(1, _currentIndex);
    _incrementIndex(1);
  }

  void _button1() {
    //_reviewCard(2, _currentIndex);
    _incrementIndex(2);
  }

  void _button2() {
    //_reviewCard(3, _currentIndex);
    _incrementIndex(3);
  }

  void _button3() {
    //_reviewCard(4, _currentIndex);
    _incrementIndex(4);
  }
  
 
  
}

