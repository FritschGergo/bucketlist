import 'package:bucketlist/pages/review_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class ViewCardHome extends StatefulWidget {
  const ViewCardHome({super.key});

  @override
  State<ViewCardHome> createState() => view_card_home();
}


class view_card_home extends State<ViewCardHome>
    with TickerProviderStateMixin {
    FirebaseFirestore db = FirebaseFirestore.instance;


  Widget buyOpenButonn()
  {
    if(globals.currentDeck["color"] == 1)
    {
      return ElevatedButton(
        child: Text('Buy'),
            onPressed: () {
            _showBuyConfirmation(context);              
                    },
      );
    }  
    return ElevatedButton(
        child: Text('Open'),
            onPressed: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => review_page()),
                );              
            },
      );
  } 
  Future<void> buy() async {
    for (var i in globals.GlobalCards){
      if(globals.currentDeck["level"] == i["level"] && globals.currentDeck["text"] == i["deck"]){
        await db.collection("users").doc(globals.UID).collection("savedCards").doc(i["id"]).set(i);
        globals.UsersCards.add(i);

      }
      //decrement token
      globals.currentDeck["color"] = 0; 
      setState(() {
        
      });
    }

  }

  _showBuyConfirmation(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          actions: [
            TextButton(
              child: Text('Buy'),
              onPressed: () {
                buy();
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
                  child: Text(globals.currentDeck["text"]),
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
                  
                  
                 
                ],
              ),
              Column(
                children: [

                  buyOpenButonn(),

                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      
                      Navigator.pop(context);
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