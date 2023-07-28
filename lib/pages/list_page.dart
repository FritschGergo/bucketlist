
import 'package:bucketlist/pages/view_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


Widget MyGridViewWidget(String deck) {
  if (deck == "WishList") {
    if (globals.host == 2) {
      deck = "HostWishList";
    } else {
      deck = "GuestWishList";
    }
  }

  List<Map> MyData = [];
  for (Map i in globals.UsersCards) {
    if (i["list"] == deck) {
      MyData.add(i);
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
          color: globals.myPrimaryColor,
          child: InkWell(
            onTap: () async {
              globals.currentCardID = MyData[index]["id"];
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => view_card()),
              );
              setState(() {});
            },
            child: Center(child: Text(MyData[index][globals.language])),
          ),
        );
      },
    ),
    floatingActionButton: deck == "BucketList" // Check if "BucketList" tab is active
        ? Stack(
            children: [
              Positioned(
                bottom: 70.0,
                right: 20.0,
                child: FloatingActionButton(
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
              ),
            ],
          )
        : null, // Hide FloatingActionButton for other tabs
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
