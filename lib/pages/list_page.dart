import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../globals.dart' as globals;


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

  Future<QuerySnapshot<Object?>> getdata(String deck) async {

  
   
   QuerySnapshot mydata = await db.collection("users").doc(globals.UID).collection("savedDecks")
    .where("name",isEqualTo: deck).get();
    QuerySnapshot cards = await db.collection("users").doc(globals.UID).collection("savedDecks").doc(mydata.docs.first.id)
    .collection("cards").where("list",isEqualTo: true).get();
    
    return cards;
  }


  Widget MyGridViewWidget(String deck){
    if(deck == "WishList"){
      if(globals.host == 2)
      {
        deck = "HostWishList";
      }
      else{
        deck = "GuestWishList";
      }
    }

    return FutureBuilder(
      future: getdata(deck),
      builder: (context , snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        List<String> MyData = [];
          for (var docSnapshot in  snapshot.data!.docs){
               var data = docSnapshot.data() as Map;
               for (var i in data.entries)
               {
                if (i.key == "text") {
                  MyData.add(i.value.toString());
              }
               }
             }
            
        return  GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                   ),
                   itemCount: MyData.length,
                   itemBuilder: (BuildContext context, int index) {
                  return Card(
                     color: Colors.red,
                     child: Center(child: Text(MyData[index])),
                                    
                  );
                }
             );
        } 
        
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
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              child: 
                Text("Bucket list")
            ),
            Tab(
              child: 
                Text("Surprise"),
            ),
            Tab(
              child: 
                Text("Done"),
            ),
            Tab(
              child: 
                Text("Places/Toys"),
            ),
            
          ],
        ),
      ),
      body: TabBarView(
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
        )
    );
  }
}
