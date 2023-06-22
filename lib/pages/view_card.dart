import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../globals.dart' as globals;

import '../auth.dart';

class view_card extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String DeckID;
  late String CardID;


  Future<Map<String, dynamic>> getdata() async {
    QuerySnapshot cards = await db.collection("users").doc(globals.UID).collection("savedDecks")
    .where("name",isEqualTo:globals.Deck).get();
    DeckID = cards.docs.first.id;
    final card = await db.collection("users").doc(globals.UID).collection("savedDecks").doc(cards.docs.first.id).collection("cards").where("text", isEqualTo: globals.CardText).get();
    CardID = card.docs.first.id;
    return card.docs.first.data();
  }

  _showDeleteConfirmation(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          actions: [
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                copyCard(globals.Deck, "delete");
                Navigator.pop(context);
                
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDoneConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          actions: [
            TextButton(
              child: Text('Done'),
              onPressed: () {
                copyCard(globals.Deck, "DoneList");
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                // Delete logic goes here
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSendToOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send to:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Bucket List'),
                onTap: () {
                  copyCard(globals.Deck, "BucketList");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Idea'),
                onTap: () {
                  copyCard(globals.Deck, "IdeasList");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Her Wish List'),
                onTap: () {
                  copyCard(globals.Deck, "HostWishList");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('His Wish List'),
                onTap: () {
                  copyCard(globals.Deck, "GuestWishList");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
               Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget textLoad() {
    return FutureBuilder(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        Map MyMap = snapshot.data as Map;
        
        return Text(MyMap["text"].toString());
        
      },
    );
  }

  void copyCard(String fromDeck, String whereDeck)
  {
   getdata().then((snaphot) => {copyCardAsisit(snaphot,fromDeck,whereDeck)});
  }

  Future<void> copyCardAsisit(Map<String, dynamic> snaphot, String fromDeck, String whereDeck) async {

  if(whereDeck != fromDeck){ 
    if(whereDeck == "delete")
    {
      await db.collection("users").doc(globals.UID).collection("savedDecks").doc(DeckID)
              .collection("cards").doc(CardID).delete();
              //.then((value) =>  Navigator.pop(context as BuildContext));
    }
    else{

      await db.collection("users").doc(globals.UID).collection("savedDecks")
      .where("name",isEqualTo: whereDeck).get().then((Qsnapshot) => {
        db.collection("users").doc(globals.UID).collection("savedDecks").doc(Qsnapshot.docs.first.id)
              .collection("cards").doc(CardID).set(snaphot).then((value) => {
                db.collection("users").doc(globals.UID).collection("savedDecks").doc(DeckID)
                  .collection("cards").doc(CardID).delete()
                    //.then((value) =>  Navigator.pop(context as BuildContext)),
              })

      });
    }
    }     
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Card(
              margin: EdgeInsets.all(50.0),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: textLoad(),
                                      //style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    child: Text('Send'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Favorite'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Cancle'),
                    onPressed: () {
                      Navigator.pop(context);
                      
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    child: Text('Done'),
                    onPressed: () {
                      
                      _showDoneConfirmation(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Move'),
                    onPressed: () {
                      _showSendToOptions(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Delete'),
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}