import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';


class listPage extends StatefulWidget {
  const listPage({super.key});

  @override
  State<listPage> createState() => _listPageState();
}

FirebaseFirestore db = FirebaseFirestore.instance;



class _listPageState extends State<listPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  

  late Map<String, dynamic> data;

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;

  Future<QuerySnapshot<Object?>> getdata(String deck) async {
   
   QuerySnapshot mydata = await db.collection("users").doc("${user?.uid}").collection("saved_decks")
    .where("name",isEqualTo: deck).get();
    
    QuerySnapshot cards = await db.collection("users").doc("${user?.uid}").collection("saved_decks").doc(mydata.docs.first.id)
    .collection("cards").where("list",isEqualTo: true).get();
    
    return cards;
  }


  Widget MyGridViewWidget(String deck){
    return FutureBuilder(
      future: getdata(deck),
      builder: (context , snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        List<String> MyData = [];
        QuerySnapshot<Object?> _querrySnapshot = snapshot.data!;
          for (var docSnapshot in _querrySnapshot.docs){
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

  Widget projectWidget(){
    return FutureBuilder(
      future: getdata("bucketList"),
      builder: (context , snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        List<String> MyData = [];
        QuerySnapshot<Object?> _querrySnapshot = snapshot.data!;
          for (var docSnapshot in _querrySnapshot.docs){
               var data = docSnapshot.data() as Map;
               for (var i in data.entries)
               {
                if (i.key == "text") {
                  MyData.add(i.value.toString());
                }
               }
             }
            
          return  TabBarView(
          controller: _tabController,
          children: [
          Center(
                child: GridView.builder(
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
             ),         
          ),
          Center(
            child: Text("It's rainy here"),
          ),
          Center(
            child: Text("It's sunny here"),
          
          ),
          Center(
            child: Text("It's sunny here"),
          
          ),
        ],
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
            child:  MyGridViewWidget("bucketList")
          ),
          Center(
            child:  MyGridViewWidget("wishList")
          ),
          Center(
            child:  MyGridViewWidget("bucketList")
          
          ),
          Center(
            child:  MyGridViewWidget("bucketList")
          
          ),
        ],
        )
    );
  }
}
