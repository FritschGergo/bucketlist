
import 'package:bucketlist/loadData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
import '../globals.dart' as globals;
//import '../auth.dart';

class view_card extends StatefulWidget {
  @override
  State<view_card> createState() => _view_cardState();
}

class _view_cardState extends State<view_card> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  int index = 0;

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
                changeDeck("DislikeList");
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
      String mypriority = "priorityHost";
      if(globals.host == 2)
      {
        mypriority = "priorityGuest";
      }
        for(int i = 0; i <= globals.UsersCards.length; i++){
          if(globals.UsersCards[i]["id"] == globals.currentCardID){
            index = i;
            if(globals.UsersCards[i][mypriority] == 0){
              updatePriority(mypriority, 2);
            }
            return Text(((globals.UsersCards[i][globals.language] != null)?
                             globals.UsersCards[i][globals.language] :
                              globals.UsersCards[i]["english"]).toString(),
                                     style: const TextStyle(
                                                    fontSize: 20 , 
                                                    //fontWeight: FontWeight.bold
                                                  ),
                                       textAlign: TextAlign.center,);

            


          }
        
        }
        return const Text("Error");   
  }

  Future<void> updatePriority(String myPriority, setPriority) async {
     await db.collection("users").doc(globals.UID).collection("savedCards").doc(globals.currentCardID).
          update({myPriority : setPriority}).then((value) => setState(() {}));
  }

  Future<void> changeDeck(String ToDeck) async {
    await db.collection("users").doc(globals.UID).collection("savedCards").doc(globals.currentCardID).update({"list" : ToDeck});
    globals.UsersCards[index]["list"] = ToDeck;
   
  }

  Widget myFavoriteButton() {
     String mypriority = "priorityHost";
      if(globals.host == 2)
      {
        mypriority = "priorityGuest";
      }

    return ElevatedButton(
                    child: globals.UsersCards[index][mypriority] == 1 ? const Text(" No Favorite") :  const Text("Favorite"),
                    
                    onPressed: () {
                      globals.UsersCards[index][mypriority] == 1 ? 
                        updatePriority(mypriority, 2) :
                        updatePriority(mypriority, 1);
                      
                    }
    );                
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.myPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Card(
                color: globals.myBackgroundColor,
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
                  myFavoriteButton(),
                  
                  
                  
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