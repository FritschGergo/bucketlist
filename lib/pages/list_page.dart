//import 'package:bucketlist/pages/review_page.dart';
import 'package:bucketlist/pages/review_page.dart';
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
        List<String> MyDataID = [];

          for (var docSnapshot in  snapshot.data!.docs){
               var data = docSnapshot.data() as Map;
               MyData.add(data["text"].toString());
               MyDataID.add(docSnapshot.id);

               
             }
            
        return  Scaffold(
          body: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                     ),
                     itemCount: MyData.length,
                     itemBuilder: (BuildContext context, int index) {
                    return Card(
                       child:InkWell(
                          onTap: () async {
                            globals.CardText = MyData[index];
                            globals.Deck = deck;
                           await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => view_card()),
                            );
                            setState(() {
                              
                            });
                            
                          },
                        child: Center(child: Text(MyData[index])),


                       )              
                      );
                    
                  }
               ),
               floatingActionButton: deck == "BucketList" // Check if "BucketList" tab is active
        ? FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => add_card()),
                            );
                            setState(() {
                              
                            });
            },
            child: Icon(Icons.add),
          )
        : null, // Hide FloatingActionButton for other tabs
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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
                Text("Bucket List"),
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
                Text("Ideas"),
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
        ),
         // Set the location of the FloatingActionButton
         
  );
    
    
  }

  
}
