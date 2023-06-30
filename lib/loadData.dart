
import 'package:bucketlist/widget_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globals.dart' as globals;

class LoadMyData{

  void loadGlobals()  { 
   if (globals.host == 0){
      db.collection("users").doc("${user?.uid}").get().then((DocumentSnapshot doc) => {
        loadGlobalAsist(doc),
        
      });
    }
  }

  Future<void> loadGlobalCards()async {
    await db.collection("cards").where("toList" ,isEqualTo: true).get()
        .then((QuerySnapshot qs) => {loadGlobalCardsAssist(qs)} );

  }

   loadGlobalCardsAssist(QuerySnapshot<Object?> qs) {

    List<Map<String, dynamic>> MyDtaList = []; 
     for (var data in qs.docs)
     {
      Map<String, dynamic> i = data.data() as Map<String, dynamic>;
      i["id"] = data.id;
      MyDtaList.add(i);

     }
     globals.GlobalCards = MyDtaList;
    }

  Future<void> loadCards()
  async {
   await db.collection("users").doc(globals.UID).collection("savedCards").where("toList" ,isEqualTo: true).get()
        .then((QuerySnapshot qs) => {loadCardsAssist(qs)} );
  }
    
  loadCardsAssist(QuerySnapshot<Object?> qs) {
     List<Map<String, dynamic>> MyDtaList = []; 
     for (var data in qs.docs)
     {
      Map<String, dynamic> i = data.data() as Map<String, dynamic>;
      i["id"] = data.id;
      MyDtaList.add(i);

     }
     globals.UsersCards = MyDtaList;
    }
    
   void loadGlobalAsist(DocumentSnapshot doc)
  {
    Map data = doc.data() as Map;
    
    if (data["host"] == 2)
    {
      globals.UID = data["partner"];
      globals.host = 2;
      db.collection("users").doc(data["partner"]).get().then((DocumentSnapshot doc) => {
        loadGlobalAsist2(doc)
      
      });
      globals.token = data["guestToken"];
    } 

    if (data["host"] == 1)
    {
      globals.UID = user!.uid;
      globals.host = 1;
      loadGlobalAsist2(doc);
      globals.token = data["hostToken"];
    }
    
    LoadMyData().loadCards().then((value) => {
      LoadMyData().loadGlobalCards().then((value) => {
        
        globals.inprogress = false,
      })
    });
  }

  loadGlobalAsist2(DocumentSnapshot<Object?> doc) {
      
      Map data2 = doc.data() as Map;
      globals.HerNinckName = data2["HerNinckName"];
      globals.HisNinckName = data2["HisNinckName"];

  }
}