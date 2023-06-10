import 'package:bucketlist/pages/review_page.dart';
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
  

  Future<QuerySnapshot<Object?>> getdata(String deck) async {
   
   QuerySnapshot cards = await db.collection("decks")
    .where("type",isEqualTo: deck).get();
    
    return cards;
  }


  Widget MyGridViewWidget(String deck){
    setState(() {
      
    });
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
               for (var i in data.entries)
               {
                if (i.key == "text") {
                  MyData.add(i.value.toString());
                  MyDataID.add(docSnapshot.id);
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
                      child:InkWell(
                        onTap: () {
                            
                            copyDeck(MyDataID[index]).then((value) => {Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => review_page()),
                            )});
                            
                          },
                        child: Center(child: Text(MyData[index])),
                     
                      )        
                  );
                }
             );
        } 
        
      );
  }

  Future<void> copyDeckAsisit(QuerySnapshot cards) async {
      for (var docs in  cards.docs.cast()){
            
            Map<String, dynamic> MyMap = {};
            for (var i in (docs.data() as Map).entries){
              MyMap.addAll({i.key : i.value});
            }
            db.collection("users").doc(globals.UID)
            .collection("InProgressDecks").doc(docs.id).get().then((DocumentSnapshot DScnapshot) async => {
              if(!DScnapshot.exists) {
                await db.collection("users").doc(globals.UID)
                .collection("InProgressDecks").doc(docs.id).set(MyMap)
              },
            
            });
            

            
    }
  }

  Future<void> copyDeck(String myDataID) async {

    //QuerySnapshot cards = await 
    db.collection("decks").doc(myDataID).collection("cards")
      .where("list", isEqualTo: true).get().then((QuerySnapshot cards) => {
      copyDeckAsisit(cards)
      });  
    
    
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
            child:  MyGridViewWidget("light")
          ),
          Center(
            child:  MyGridViewWidget("medium")
          ),
          Center(
            child:  MyGridViewWidget("extreme")
          
          ),
        ],
        )
    );
  }
  
}