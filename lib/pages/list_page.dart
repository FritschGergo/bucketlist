
import 'package:bucketlist/pages/view_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../globals.dart' as globals;
import 'add_card.dart';


class listPage extends StatefulWidget {
  const listPage({super.key});

  @override
  State<listPage> createState() => _listPageState();
}


class _listPageState extends State<listPage>
    with TickerProviderStateMixin {

  late TabController _tabController;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;
  bool isFilterdLevel = false;
  String deckFilter = "";
  int level = 0;
  bool buttonsOpen = false; 

  void levelPick() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: 250,
        child: CupertinoPicker(
          backgroundColor: Colors.black.withOpacity(0.5),
          scrollController: FixedExtentScrollController(initialItem: level),
          onSelectedItemChanged: (int value) async {
            setState(() {
              level = value;
            });
          },
          itemExtent: 40, // Ezt állítsd az elemek magasságának megfelelően
          children: [
            Text(globals.languageMap["homeLight"], style: const TextStyle( color: Colors.white)),
            Text(globals.languageMap["homeMedium"],  style: const TextStyle( color: Colors.white)),
            Text(globals.languageMap["homeExtreme"],  style: const TextStyle( color: Colors.white)),
          ],
        ),
      ),
    );
  }
  
  void deckPcik(){
    List<String> decks = [];
    List<String> languageDecks = [];
    
    for (var i in globals.UsersCards)
    {
      if(!decks.contains(i["deck"]))
      {
        decks.add(i["deck"]);
        languageDecks.add((i["${globals.language}Deck"]));
      }
       
    }
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: 250,
        child: CupertinoPicker(
          backgroundColor: Colors.black.withOpacity(0.5),
         scrollController: FixedExtentScrollController(initialItem: 0),
          onSelectedItemChanged: (int value) async {
            setState(() {
              deckFilter = decks[value];
            });
          },
          itemExtent: 40, // Ezt állítsd az elemek magasságának megfelelően
          children:  List<Widget>.generate(decks.length, (index) {
            return Text(
              languageDecks[index],
              style: const TextStyle(fontSize: 20,
                  color: Colors.white),
           
            );
          }),
        ),
      ),
    );

  }

  Widget buttons(String deck, List<Map> myData)
  {
      
      return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (buttonsOpen)
                FloatingActionButton(
                heroTag: "btn3",
                backgroundColor: globals.myBackgroundColor,
                onPressed: () async {
                  updatePriority("", myData);
                  setState(() {
                    
                  });
                  
                },
                child: const Icon(Icons.visibility_outlined, color: Colors.white)
              ), 
              if (buttonsOpen)
               const SizedBox(height: 10), 

              if (buttonsOpen)
                FloatingActionButton(
                heroTag: "btn4",
                backgroundColor: globals.myBackgroundColor,
                onPressed: () async {
                  setState(() {
                    
                  });
                  
                },
                child: const Icon(Icons.search, color: Colors.white)
              ), 
              if (buttonsOpen)
               const SizedBox(height: 10), 

              if (buttonsOpen)
                FloatingActionButton(
                heroTag: "btn5",
                backgroundColor: globals.myBackgroundColor,
                onPressed: () async {
                  if (deckFilter == "")
                  {
                    deckPcik();
                    setState(() {
                      
                    });
                  }
                  else{
                     setState(() {
                      deckFilter = "";
                  });
                  }
                 
                 
                  
                },
                child: deckFilter == "" ? const Icon(Icons.filter_list, color: Colors.white) : const Icon(Icons.filter_list_off, color: Colors.white)
              ), 
              if (buttonsOpen)
               const SizedBox(height: 10),

              if (buttonsOpen)
                FloatingActionButton(
                heroTag: "btn1",
                backgroundColor: globals.myBackgroundColor,
                onPressed: () async {
                  !isFilterdLevel? levelPick() : null;
                  setState(() {
                    isFilterdLevel = !isFilterdLevel;
                  });
                  
                },
                child:isFilterdLevel? const Icon(Icons.filter_alt_off, color: Colors.white) :  const Icon(Icons.filter_alt, color: Colors.white,),
              ), 
              if (buttonsOpen)
               const SizedBox(height: 10), 
      
              if (deck == "BucketList" && buttonsOpen) // Check if "BucketList" tab is active
                FloatingActionButton(
                  heroTag: "btn0",
                  backgroundColor: globals.myBackgroundColor,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => add_card()),
                    );
                    setState(() {});
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              if (buttonsOpen)
                const SizedBox(height: 10),
              
              FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: globals.myBackgroundColor,
                  onPressed: () async {
                    
                    setState(() {
                      buttonsOpen =!buttonsOpen;
                    });
                    
                  },
                  child:buttonsOpen? const Icon(Icons.arrow_downward, color: Colors.white) :  const Icon(Icons.more_vert, color: Colors.white),
                ),
                const SizedBox(height: 55),
            ],
          );
    
     
  }
  
  Color myColor(int j) {
    if(j == 0)
    {
      return globals.myPrimaryColor;
    }
    if(j == 1){
      return globals.mySecondaryColor;
    }
    return globals.myTertiaryColor;
}

  Widget MyGridViewWidget(String deck) {

    String mypriority = "priorityHost";
      if(globals.host == 2)
      {
        mypriority = "priorityGuest";
      }

    if (deck == "WishList") {
      if (globals.host == 2) {
        deck = "HostWishList";
      } else {
        deck = "GuestWishList";
      }
    }

    List<Map> MyData = [];
    for (int j = 0; j < 3; j++)
    {
      for (Map i in globals.UsersCards) {
          if ((isFilterdLevel?  (i["list"] == deck && i["level"] == level) : i["list"] == deck)
            && i[mypriority] == j
            &&  (deckFilter == "" || deckFilter == i["deck"])) 
          {
            i["color"] = myColor(j);
            MyData.add(i);
          }
        }
    }

    
  
    bool pressed = true;
    return Scaffold(
      
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemCount: MyData.length,
        itemBuilder: (BuildContext context, int index) {
          String textToShow = (MyData[index][globals.language] != null)
              ? MyData[index][globals.language]
              : MyData[index]["english"];

          if (textToShow.length > 50) {
            textToShow = textToShow.substring(0, 50) + "...";
}
          return Card(
            
            color: MyData[index]["color"],
            child: InkWell(
              onLongPress:   () {
                updatePriority(MyData[index]["id"], MyData);
              },
              onTap: () async {
                globals.currentCardID = MyData[index]["id"];
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => view_card()),
                );
                setState(() {});
              },
              
              child: Center(child: Text(
                   textToShow, 
                      style: const TextStyle(
                        fontSize: 17 , 
                    
                      ),
                      textAlign: TextAlign.center,),
            ),
          )
          );
        },
      ),
      
      
      floatingActionButton: buttons(deck, MyData),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    

    );
  } 

   Future<void> updatePriority(String id, List<Map> myData ) async {
    for (var i in myData)
    {
      if (i["id"] == id || id == "")
      {
        String myPriority = "priorityHost";
        if(globals.host == 2)
        {
          myPriority = "priorityGuest";
        }
        if(i[myPriority] == 0){
           await db.collection("users").doc(globals.UID).collection("savedCards").doc(i["id"]).
          update({myPriority : 2}).then((value) => setState(() {}));
        }
        if (i["id"] == id)
        {
          break; 
        }
         
      }

    }
    
    
  }





  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(
      length: 4, 
      vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.myPrimaryColor,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: 
                Text(globals.languageMap["listBucketList"].toString()),
            ),
            Tab(
              child: 
                Text(globals.languageMap["listSurprise"].toString()),
            ),
            Tab(
              child: 
                Text(globals.languageMap["ListDone"].toString()),
            ),
            Tab(
              child: 
                Text(globals.languageMap["ListIdea"].toString()),
            ),
            
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child:TabBarView(
            controller: _tabController,
            children: [
            Center(
              child:  MyGridViewWidget("BucketList")
              
            ),
            Center(
              child: MyGridViewWidget("WishList")
            ),
            Center(
              child:  MyGridViewWidget("DoneList")
            
            ),
            Center(
              child:  MyGridViewWidget("IdeasList")
            
            ),
          ],
        ),
      )
  );
    
    
  }

  
}


