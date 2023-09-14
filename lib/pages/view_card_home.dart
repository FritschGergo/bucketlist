import 'dart:math';

import 'package:bucketlist/pages/erarnToken.dart';
import 'package:bucketlist/pages/review_page.dart';
import 'package:bucketlist/widget_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../globals.dart' as globals;

class ViewCardHome extends StatefulWidget {
  const ViewCardHome({super.key});

  @override
  State<ViewCardHome> createState() => view_card_home();
}


class view_card_home extends State<ViewCardHome>
    with TickerProviderStateMixin {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final User? user = Auth().correntUser;
    bool inprogress = false;


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
            onPressed: () async {
               await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => review_page()),
                );              
            },
      );
  } 
  Future<void> buyAssist(int price) async {
    setState(() {
      inprogress = true;
    }); 

    await db.collection("users").doc(user?.uid).update({"token" : FieldValue.increment(-price)});
    globals.token = globals.token - price;

    for (var i in globals.GlobalCards){
      if(globals.currentDeck["level"] == i["level"] && globals.currentDeck["text"] == i["deck"]){
        
        await db.collection("users").doc(globals.UID).collection("savedCards").doc(i["id"]).set(i);
        
        //globals.UsersCards.add(i);

      }
      

    }
    
    setState(() {
      inprogress = false;
    });          
    globals.currentDeck["color"] = 0; 
  }

  void buy(){
    int price = 1;
    if(globals.token - price >= 0)
    {
      buyAssist(price); 
    }
    else
    {
      showNoToken();
    }
  }

  void showNoToken() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You dont have enough token'),
          actions: [
            TextButton(
              child: Text('Buy/Earn Token'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  earnToken()),
                            );
               
                
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
                Navigator.pop(context);
                buy();
                
                
                
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

  Future<void> loadDailydeck() async {
    const numberOfdailyCard = 5;
    Random random = Random();
    List<Map<String, dynamic>> MyCards = [];
    List<int> randLsit = [];

    for (int i = 0; i < globals.GlobalCards.length; i++)
    {
      if(globals.GlobalCards[i]["level"] == globals.currentDeck["level"])
      {
       bool contains = false;
      for(int j = 0; j < globals.UsersCards.length; j++){
        if(globals.GlobalCards[i]["id"] == globals.UsersCards[j]["id"])
        {
          contains = true;
          break;
          
        }
      }
      if(!contains)
      {
        Map<String, dynamic> currentCard = Map.from(globals.GlobalCards[i]);

        currentCard["deck"] = "dailyDeck";

        MyCards.add(currentCard);
        
        
      } 
    }
  }

    if (MyCards.length >= numberOfdailyCard)
    {
      for(int i = 0; i < numberOfdailyCard; i++)
      { int rand;
        do {
        rand = random.nextInt(MyCards.length);
        } while (randLsit.contains(rand));
        randLsit.add(rand);

        //globals.UsersCards.add(MyCards[rand]);
        await db.collection("users").doc(globals.UID).collection("savedCards").doc(MyCards[rand]["id"]).set(MyCards[rand]);
      }
      
      globals.dailyDeckCompleted = true;
      await db.collection("users").doc(globals.UID).update({"dailyDeckCompleted" : true});

      setState(() {
        inprogress = false;
      }); 
    }
    else{
      print("you have all the crads"); //tájékoztatni a fekhasználót!!
      Navigator.pop(context);
    }
  }
  

  Widget myWidget(){
    if(!globals.dailyDeckCompleted && globals.currentDeck["text"] == "dailyDeck")
    {
      inprogress = true;
      loadDailydeck();
    }

    if(inprogress)
    {
      return const Center(
       child: CircularProgressIndicator()
      );
    }

    return Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Card(
                color: globals.myBackgroundColor,
              margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(globals.currentDeck["languageDeck"],
                                     style: const TextStyle(
                                                    fontSize: 20 , 
                                                    //fontWeight: FontWeight.bold
                                                  ),
                                       textAlign: TextAlign.center,)
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
           child: Center(
            child: buyOpenButonn(),)
          )
            
                  
                  
                 

            
          
        ],
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
      body: myWidget()
    );
  }
  
  
  
  
  
}