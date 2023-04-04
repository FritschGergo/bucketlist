import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../auth.dart';
import '../main.dart';
import 'navigaton_page.dart';
class review_page extends StatefulWidget {
  const review_page({super.key});

  @override
  State<review_page> createState() => _review_page();
  

}
 
class _review_page extends State<review_page> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;
  int _currentIndex = 0;
 
  
  final List<String> _strings = [
    "String 1",
    "String 2",
    "String 3",
    "String 4",
    "String 5",
    "String 6",
    "String 7",
    "String 8",
    "String 9",
    "String 10",
    "String 11",
    "String 12",
    "String 13",
    "String 14",
    "String 15",
    "String 16",
    "String 17",
    "String 18",
    "String 19",
    "String 20",
  ];


  void _incrementIndex() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % 20;
    });
  }



  Future<QuerySnapshot<Object?>> getdata() async {
   
   QuerySnapshot cards = await db.collection("users").doc("${user?.uid}").collection("InProgressDecks")
    .where("list",isEqualTo: true).get();
    
    return cards;
  }


   Widget _currentCard() {
    //i = 0   like
    //i = 1   ok / maybe
    //i = 2   later
    //i = 3   dislike
    List<String> MyData = [];
    List<String> MyDataID = [];

    
      return FutureBuilder(
        future: getdata(),
        builder: (context , snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
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
        if(MyData.length <= _currentIndex)
        {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          },);
         
        }
        else{
        
        return Text(MyData[_currentIndex]);
        }
         return const Text("done");
    }
      );
    
    
    
    


  }
  
  

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Card(
              margin: EdgeInsets.all(50.0),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: _currentCard(),
                                      //style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
            
          
          SizedBox(
            height: 100.0,
            width: double.infinity,
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: _incrementIndex,
                    tooltip: 'Previous',
                    child: const Icon(Icons.favorite),
                  ),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: _incrementIndex,
                    tooltip: 'Next',
                    child: Icon(Icons.thumb_up),
                  ),
                  FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: _incrementIndex,
                    tooltip: 'Button 1',
                    child: Icon(Icons.watch_later),
                  ),
                  FloatingActionButton(
                    heroTag: "btn0",
                    onPressed: _incrementIndex,
                    tooltip: 'Button 2',
                    child: Icon(Icons.thumb_down),
                  ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
  
}
