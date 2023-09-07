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
  int index = 0;
  int swipeDirection = 0;
  

  List<Map> MyData = [];
  
  void _incrementIndex(int i) {
    if (index >= MyData.length -1 ){
          Navigator.pop(context);
          Navigator.pop(context);
        }
    else if(index + i >= 0){

       setState(() {
      index+= i;
      });
    }
   
  }

  void loadData(){
    int reviewed = 0;
    String myHost = "hostReview";
    if(globals.host == 2)
    {
      myHost = "guestReview";
    }
    if(MyData.isEmpty){
      for (var i in globals.UsersCards){
          if((i["level"] == globals.currentDeck["level"] && i["deck"] == globals.currentDeck["text"]) ||
          globals.currentDeck["text"] == i["list"])           //  ==> Nem egyezhet meg semilyen list semilyn deck nevével!!!
          { 
            MyData.add(i);
            if(i[myHost] != 0) reviewed++;
            
          }
        }
      if(MyData.length != reviewed && reviewed != 0)
      {
        checkData();
      }
      

      }  
  }

  void checkData(){      // ha vegyesen van benne má értékelt és még nem akkor csak azoka hozza fel amiylen nem értékelt
    String myHost = "hostReview";
    List<Map> NewMyData = [];
    if(globals.host == 2)
    {
      myHost = "guestReview";
    }
    for(var i in MyData)
    {
      if(i[myHost] == 0) NewMyData.add(i);
    }
    MyData = NewMyData;

  }

  Future<void> updateReview(String list, int i, int index, String myHost, int vote) async {

    await db.collection("users").doc(globals.UID).collection("savedCards").doc(MyData[index]["id"])
    .update({"list" : list,
              myHost : vote});
    //globals.UsersCards[i]["list"] = list;

  }

  Future<void> setReview(int vote) async {
    String myHost = "hostReview";
    String myGuest = "guestReview";
    if(globals.host == 2)
    {
      myHost = "guestReview";
      myGuest = "hostReview";
    }

    
    
    for(int i = 0; i < globals.UsersCards.length; i++){
      if(MyData[index]["id"] == globals.UsersCards[i]["id"])
      {
        globals.UsersCards[i][myHost] = vote;
        
        if(globals.UsersCards[i][myGuest] != 0)
        {
          int reviewHost = globals.UsersCards[i][myHost];
          int reviewGuest = globals.UsersCards[i][myGuest];
      
                if(reviewHost == 4 || reviewGuest == 4){
                  //delete card 
                  updateReview("DislikeList", i, index, myHost ,vote);
                  break;
                  
                }
                else if(reviewHost == 3 || reviewGuest == 3){
                  //later deck
                  updateReview("LaterList", i, index, myHost ,vote);
                  break;
                }
                else if(reviewHost == 1 && reviewGuest == 1){
                  //Bucket List deck
                  updateReview("BucketList", i, index, myHost ,vote);
                  break;
                  
                }
                else if(reviewHost == 2 && reviewGuest == 2){
                  //ideas card 
                  updateReview("IdeasList", i, index, myHost ,vote);
                  break;
                  
                }
                else if(reviewHost == 1 && reviewGuest == 2){
                  //Host Wishes deck
                  updateReview("HostWishList", i, index, myHost ,vote);
                  break;
                }
                else if(reviewHost == 2 && reviewGuest == 1){
                  //Host Guest deck
                  updateReview("GuestWishList", i, index, myHost ,vote);
                  break;
                }
        }else{
          await db.collection("users").doc(globals.UID).collection("savedCards").doc(MyData[index]["id"]).update({myHost : vote});
        }

        break;
        

      }
    }
    //i = 0   no rewiwe
    //i = 1   like
    //i = 2   ok / maybe
    //i = 3   later
    //i = 4   dislike
    
    _incrementIndex(1);
  }
  
  
  void _button0() {
    setReview(1);
    
  }

  void _button1() {
    setReview(2);
    
  }

  void _button2() {
    setReview(3);
    
  }

  void _button3() {
    setReview(4);
    
  }

  Color myColor(int i) {
    if(i == swipeDirection)
    {
      return Colors.white;
    }


    String myHost = "hostReview";
    if(globals.host == 2)
    {
      myHost = "guestReview";
    }
    if(MyData[index][myHost] == i && i != 0)
    {
      return Color.fromARGB(255, 110, 0, 0);
    }
    return Colors.red;
    
  }

  void cardOnTap() {
    String myHost = "hostReview";
    if(globals.host == 2)
    {
      myHost = "guestReview";
    }
    if(MyData[index][myHost] != 0)
    {
      _incrementIndex(1);
    }
  
  }

  Widget myGestureDetector() {
    return  GestureDetector(
      onTap: cardOnTap,
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0) {
          // Swipe Up
          if(swipeDirection != 2)
          {
            setState(() {
               swipeDirection = 2;
            });
          }
          
        } else if (details.delta.dy > 0) {
          // Swipe Down
          if(swipeDirection != 3)
          {
            setState(() {
               swipeDirection = 3;
            });
          }
        }
      },
      onVerticalDragEnd: (details) {
        // You can handle the drag end event if needed
        if(swipeDirection == 2) _button1();
        if(swipeDirection == 3) _button2();
        swipeDirection = 0;
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < 0) {
          // Swipe Left
          if(swipeDirection != 4)
          {
            setState(() {
               swipeDirection = 4;
            });
          }
        } else if (details.delta.dx > 0) {
          // Swipe Right
          if(swipeDirection != 1)
          {
            setState(() {
               swipeDirection = 1;
            });
          }
        }
      },
      onHorizontalDragEnd: (details) {
        // You can handle the drag end event if needed
        if(swipeDirection == 1) {_button0();}
        if(swipeDirection == 4) _button3();
        swipeDirection = 0;
      },
      child: Card(
        margin: EdgeInsets.all(50.0),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              (MyData[index][globals.language] != null)
                  ? MyData[index][globals.language]
                  : MyData[index]["english"],
            ),
          ),
        ),
      ),
    );
  }
  

 @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
            backgroundColor: globals.myPrimaryColor,
            toolbarHeight: 50,
            actions: <Widget>[
              TextButton(
                child: Text("Previous" ,
                style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _incrementIndex(-1);
                },
              ),
            ],
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: myGestureDetector(),
            ),
            
          SizedBox(
            height: 100.0,
            width: double.infinity,
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "btn0",
                    onPressed: _button3,
                    backgroundColor: myColor(4),
                    tooltip: 'Dislike',
                    child: const Icon(Icons.thumb_down),
                  ),
                  FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: _button2,
                    backgroundColor: myColor(3),
                    tooltip: 'Later',
                    child: const Icon(Icons.watch_later),
                  ),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: _button1,
                    backgroundColor: myColor(2),
                    tooltip: 'Like',
                    child: const Icon(Icons.thumb_up),
                  ),
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: _button0,
                    backgroundColor: myColor(1),
                    tooltip: 'Love',
                    child: const Icon(Icons.favorite),
                  ),
                  
                  
                  
              ],
            ),
          ),
        ],
      ),
      
    );
  }
  
  
  
}
