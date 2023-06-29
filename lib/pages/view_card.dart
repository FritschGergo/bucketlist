import 'package:bucketlist/loadData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
import '../globals.dart' as globals;
//import '../auth.dart';

class view_card extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int index = 0;
  bool pop = false;

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
                changeDeck("delete");
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
                changeDeck("DoneList");
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
                  changeDeck("BucketList");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Idea'),
                onTap: () {
                  changeDeck("IdeasList");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Her Wish List'),
                onTap: () {
                  changeDeck("HostWishList");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('His Wish List'),
                onTap: () {
                  changeDeck("GuestWishList");
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
        
        for(int i = 0; i <= globals.UsersCards.length; i++){
          if(globals.UsersCards[i]["id"] == globals.currentCardID){
            index = i;
            return Text(globals.UsersCards[i]["text"].toString());
          }
        
        }
        return const Text("Error");   
  }

  Future<void> changeDeck(String ToDeck) async {
    await db.collection("users").doc(globals.UID).collection("savedCards").doc(globals.currentCardID).update({"list" : ToDeck});
    globals.UsersCards[index]["list"] = ToDeck;
   
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