import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../auth.dart';

class review_page extends StatefulWidget {
  const review_page({super.key});

  @override
  State<review_page> createState() => _review_page();
  

}
 
class _review_page extends State<review_page> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;
  int index = 0;
  

  List<Map> MyData = [];
  
  void _incrementIndex() {
    
    setState(() {
      index++;
      if (index >= MyData.length -1 ){
        Navigator.pop(context);
        Navigator.pop(context);
      }

    });
  }

  void loadData(){
    if(index == 0){
      for (var i in globals.UsersCards){
          if(i["level"] == globals.currentDeck["level"] && i["deck"] == globals.currentDeck["text"])
          { 
            MyData.add(i);
          }
      }
      MyData.add({"text" : "end"});
      }  
  }

  Future<void> updateReview(String list, int i, int index2) async {

    await db.collection("users").doc(globals.UID).collection("savedCards").doc(MyData[index2]["id"])
    .update({"list" : list});
    globals.UsersCards[i]["list"] = list;

  }

  Future<void> setReview(int vote, int index2) async {
    String myHost = "hostReview";
    String myGuest = "guestReview";
    if(globals.host == 2)
    {
      myHost = "guestReview";
      myGuest = "hostReview";
    }

    await db.collection("users").doc(globals.UID).collection("savedCards").doc(MyData[index2]["id"]).update({myHost : vote});
    
    for(int i = 0; i < globals.UsersCards.length; i++){
      if(MyData[index2]["id"] == globals.UsersCards[i]["id"])
      {
        globals.UsersCards[i][myHost] = vote;
        if(globals.UsersCards[i][myGuest] != 0)
        {
          int reviewHost = globals.UsersCards[i][myHost];
          int reviewGuest = globals.UsersCards[i][myGuest];
      
                if(reviewHost == 4 || reviewGuest == 4){
                  //delete card 
                  updateReview("DislikeList", i, index2);
                  break;
                  
                }
                else if(reviewHost == 3 || reviewGuest == 3){
                  //later deck
                  updateReview("LaterList", i, index2);
                  break;
                }
                else if(reviewHost == 1 && reviewGuest == 1){
                  //Bucket List deck
                  updateReview("BucketList", i, index2);
                  break;
                  
                }
                else if(reviewHost == 2 && reviewGuest == 2){
                  //ideas card 
                  updateReview("IdeasList", i, index2);
                  break;
                  
                }
                else if(reviewHost == 1 && reviewGuest == 2){
                  //Host Wishes deck
                  updateReview("HostWishList", i, index2);
                  break;
                }
                else if(reviewHost == 2 && reviewGuest == 1){
                  //Host Guest deck
                  updateReview("GuestWishList", i, index2);
                  break;
                }



        }
        

      }

    }

    //i = 0   no rewiwe
    //i = 1   like
    //i = 2   ok / maybe
    //i = 3   later
    //i = 4   dislike

  }
  
  
  void _button0() {
    setReview(1, index);
    _incrementIndex();
  }

  void _button1() {
    setReview(2, index);
    _incrementIndex();
  }

  void _button2() {
    setReview(3, index);
    _incrementIndex();
  }

  void _button3() {
    setReview(4, index);
    _incrementIndex();
  }
  

 @override
  Widget build(BuildContext context) {
    loadData();
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
                  child: Text(MyData[index]["text"]),
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

  
}
