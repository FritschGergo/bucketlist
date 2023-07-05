import 'package:bucketlist/pages/view_card_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../auth.dart';
import '../globals.dart' as globals;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {

  late TabController _tabController;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;

  List<Map> loadData(int level) {
    
    List<Map> MyData = [];
    String myHost = "hostReview";
    List<String> newDeck = [];
    List<String> ownedDeck= [];
    List<String> Deck = [];
    List<String> newDeckLanguage = [];
    List<String> ownedDeckLanguage= [];
    List<String> DeckLanguage = [];
    

    bool laterList = false;
    
    if(globals.host == 2)
    {
      myHost = "guestReview";
    }
    
    for(var i in globals.UsersCards)
    { 
      if(i["list"].toString() == "LaterList")
      {
        laterList = true;
      }

      if(i["level"] == level)
        {
          if(i[myHost] == 0){
            if(!newDeck.contains(i["deck"].toString()))
            {
              newDeck.add(i["deck"].toString());
              newDeckLanguage.add(i["${globals.language}Deck"]);
            }
          }

          if(!ownedDeck.contains(i["deck"].toString()))
          {
              ownedDeck.add(i["deck"].toString());
              ownedDeckLanguage.add(i["${globals.language}Deck"]);
          }
      }
    }
    for (var i in globals.GlobalCards){
     if(!Deck.contains(i["deck"].toString()) && i["level"] == level)
        {
              Deck.add(i["deck"].toString());
              DeckLanguage.add(i["${globals.language}Deck"]);
        }
    }
    
    for (int i = 0; i < newDeck.length; i++)
    {
        MyData.add({
            "text": newDeck[i],
            "languageDeck" : newDeckLanguage[i],
            "color": 0,
            "level" : level
          });
    }
    for (int i = 0; i < Deck.length; i++)
    {
      if(!ownedDeck.contains(Deck[i])){
        MyData.add({
          "text"  : Deck[i],
          "languageDeck" : DeckLanguage[i],
          "color" : 1,
          "level" : level
        });
      } 
    }
    if (laterList){
          MyData.add({
                "text": "LaterList",
                "languageDeck" : "LaterList",
                "color": 2,
                "level" : level
          });
    }
    for (int i = 0; i < ownedDeck.length; i++)
    {
      if(!newDeck.contains(ownedDeck[i]))
      {
          MyData.add({
            "text": ownedDeck[i],
            "languageDeck" : ownedDeckLanguage[i],
            "color": 2,
            "level" : level
          });
      }    
    }
    
    return MyData;
  }

  Color? myColor(int c){
    if(c == 0)
    {
      return Colors.blue[300];
    }
    if(c == 1)
    {
      return Colors.red[800];
    }
    return Colors.black12;
    
  }

  Widget MyGridViewWidget(int level){
    List<Map> MyData = loadData(level);


        return  GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                   ),
                   itemCount: MyData.length,
                   itemBuilder: (BuildContext context, int index) {
                  return Card(
                      
                      color: myColor(MyData[index]["color"]),
                      child:InkWell(
                        onTap: () {
                            globals.currentDeck = MyData[index];
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewCardHome()),
                            );
                            
                          },
                        child: Center(child: Text(MyData[index]["languageDeck"])),
                     
                      )        
                  );
                }
             );
        
  }
  
  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(
      length: 3, 
      vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: 
                Text(globals.languageMap["homeLight"].toString())
            ),
            Tab(
              child: 
                Text(globals.languageMap["homeMedium"].toString()),
            ),
            Tab(
              child: 
                Text(globals.languageMap["homeExtreme"].toString()),
            ),
            
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
          Center(
            child:  MyGridViewWidget(0)
          ),
          Center(
            child:  MyGridViewWidget(1)
          ),
          Center(
            child:  MyGridViewWidget(2)
          
          ),
        ],
        )
    );
  }
  
}