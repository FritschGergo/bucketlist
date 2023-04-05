import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../auth.dart';
class review_page extends StatefulWidget {
  const review_page({super.key});

  @override
  State<review_page> createState() => _review_page();
  

}
 
class _review_page extends State<review_page> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;
  int _currentIndex = 0;
  int _previusReview = 0;
 
  void _incrementIndex(int review) {
    setState(() {
      _currentIndex = (_currentIndex + 1) % 20;
      _previusReview = review;
    });
  }

  Future<QuerySnapshot<Object?>> getdata() async {
   
   QuerySnapshot cards = await db.collection("users").doc("${user?.uid}").collection("InProgressDecks")
    .where("list",isEqualTo: true).get();
    
    return cards;
  }

  Future<void> setreView(String id, int review) async {
    await db.collection("users").doc("${user?.uid}")
            .collection("InProgressDecks").doc(id).update({"review" : review});
  }


  Widget _currentCard() {
    //i = 0   no rewiwe
    //i = 1   like
    //i = 2   ok / maybe
    //i = 3   later
    //i = 4   dislike
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

        if(_currentIndex > 0){
           setreView(MyDataID[_currentIndex-1], _previusReview);

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
                    onPressed: _button0,
                    tooltip: 'Previous',
                    child: const Icon(Icons.favorite),
                  ),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: _button1,
                    tooltip: 'Next',
                    child: const Icon(Icons.thumb_up),
                  ),
                  FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: _button2,
                    tooltip: 'Button 1',
                    child: const Icon(Icons.watch_later),
                  ),
                  FloatingActionButton(
                    heroTag: "btn0",
                    onPressed: _button3,
                    tooltip: 'Button 2',
                    child: const Icon(Icons.thumb_down),
                  ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
  
  
  void _button0() {
    //_reviewCard(1, _currentIndex);
    _incrementIndex(1);
  }

  void _button1() {
    //_reviewCard(2, _currentIndex);
    _incrementIndex(2);
  }

  void _button2() {
    //_reviewCard(3, _currentIndex);
    _incrementIndex(3);
  }

  void _button3() {
    //_reviewCard(4, _currentIndex);
    _incrementIndex(4);
  }
}


