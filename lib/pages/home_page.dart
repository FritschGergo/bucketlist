import 'package:bucketlist/pages/view_card_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    
    
    if(globals.host == 2)
    {
      myHost = "guestReview";
    }
    
    for(var i in globals.UsersCards)
    {   
      if(i["level"] == level)
        {
          if(i[myHost] == 0){
            if(!newDeck.contains(i["deck"].toString()))
            {
              newDeck.add(i["deck"].toString());
            }
          }

          if(!ownedDeck.contains(i["deck"].toString()))
          {
              ownedDeck.add(i["deck"].toString());
          }
      }
    }
    for (var i in globals.GlobalCards){
     if(!Deck.contains(i["deck"].toString()) && i["level"] == level)
        {
              Deck.add(i["deck"].toString());
        }
    }
    
    for (var i in newDeck)
    {
        MyData.add({
            "text": i,
            "color": 0,
            "level" : level
          });
    }
        
    for (var i in Deck)
    {
      if(!ownedDeck.contains(i)){
        MyData.add({
          "text"  : i,
          "color" : 1,
          "level" : level
        });
      } 
    }

    for (var i in ownedDeck)
    {
      if(!newDeck.contains(i))
      {
          MyData.add({
            "text": i,
            "color": 0,
            "level" : level
      });

      }
      
    }

      
      
      return MyData;
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
                      
                      child:InkWell(
                        onTap: () {
                            globals.currentDeck = MyData[index];
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewCardHome()),
                            );
                            
                          },
                        child: Center(child: Text(MyData[index]["text"])),
                     
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
          tabs: const <Widget>[
            Tab(
              child: 
                Text("Könnyed")
            ),
            Tab(
              child: 
                Text("Huncut"),
            ),
            Tab(
              child: 
                Text("Extrém"),
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