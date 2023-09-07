
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
  bool isFilterd = false;
  int level = 0;

  void levelPick() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: 250,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: level),
          onSelectedItemChanged: (int value) async {
            setState(() {
              level = value;
            });
          },
          itemExtent: 40, // Ezt állítsd az elemek magasságának megfelelően
          children: [
            Text(globals.languageMap["homeLight"]),
            Text(globals.languageMap["homeMedium"]),
            Text(globals.languageMap["homeExtreme"]),
          ],
        ),
      ),
    );
    }
  Widget buttons(String deck)
  {
    return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      // New FloatingActionButton
      FloatingActionButton(
        heroTag: "btn1",
        backgroundColor: Colors.red.withOpacity(0.8),
        onPressed: () async {
          !isFilterd? levelPick() : null;
          setState(() {
            isFilterd = !isFilterd;
          });
          
        },
        child:isFilterd? Icon(Icons.filter_alt_off) : Icon(Icons.filter_alt),
      ),
      SizedBox(height: 10), // Add some spacing between the FloatingActionButton widgets
      // Existing FloatingActionButton
      if (deck == "BucketList") // Check if "BucketList" tab is active
        FloatingActionButton(
          heroTag: "btn0",
          backgroundColor: Colors.red.withOpacity(0.8),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => add_card()),
            );
            setState(() {});
          },
          child: Icon(Icons.add),
        ),
      SizedBox(height: 55), 
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
          if ((isFilterd?  (i["list"] == deck && i["level"] == level) : i["list"] == deck) && 
          i[mypriority] == j) {
            i["color"] = myColor(j);
            MyData.add(i);
          }
        }
    }
  




    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemCount: MyData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: MyData[index]["color"],
            child: InkWell(
              onTap: () async {
                globals.currentCardID = MyData[index]["id"];
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => view_card()),
                );
                setState(() {});
              },
              
              child: Center(child: Text((MyData[index][globals.language] != null)? MyData[index][globals.language] : MyData[index]["english"], 
                                                  style: const TextStyle(
                                                    fontSize: 17 , 
                                                    fontWeight: FontWeight.bold
                                                  ),
                                       textAlign: TextAlign.center,)),
            ),
          );
        },
      ),
      
      
      floatingActionButton: buttons(deck),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    

    );
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


