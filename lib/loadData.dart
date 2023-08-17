import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';
import '../globals.dart' as globals;
import 'auth.dart';

class LoadMyData{ 
  final User? user = Auth().correntUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  

  void loadGlobals()  { 
    {
      if (globals.host == 0 ){
        db.collection("users").doc(user?.uid).get().then((DocumentSnapshot doc) => {
          
          loadGlobalAsist(doc),
          
        });
      }
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
    
  void loadGlobalAsist(DocumentSnapshot doc) async 
  {
    if (doc.exists)
    {
        Map data = doc.data() as Map;
        
        if (data["host"] == 2)
        {
          globals.UID = data["partner"];
          globals.host = 2;
          db.collection("users").doc(data["partner"]).get().then((DocumentSnapshot doc2) => {
            loadGlobalAsist2(doc2)
          
          });
          globals.token = data["token"];
        }

        if (data["host"] == 1)
        {
          globals.UID = user!.uid;
          globals.host = 1;
          loadGlobalAsist2(doc);
          globals.token = data["token"];
        }

        if (data["host"] == 3) 
        {
          globals.host = 3;
          globals.UID = user!.uid;
          loadLanguage("english");
        }

        
        loadCards().then((value) => {
          loadGlobalCards().then((value) => {
            
            globals.inprogress = false,
          })
        });
    }else
    { 
      globals.UID = user!.uid;
       await db.collection("users").doc(user?.uid).set({
                    "host" : 3,                // guest= 0(idk) 1(host) 2(guest) 3(ready to pair)
                    }).then((value) => loadGlobals());
      loadLanguage(globals.language);
      print("no data");

    }
    
  }

  loadGlobalAsist2(DocumentSnapshot<Object?> doc) {

      
  
      Map data2 = doc.data() as Map;
      
      globals.HerNinckName = data2["HerNinckName"];
      globals.HisNinckName = data2["HisNinckName"];
      globals.language = data2["language"];
      globals.dailyDeckCompleted = data2["dailyDeckCompleted"];
      loadLanguage(globals.language);
      allLanguageLoad();
      loadDate(data2["previusDate"].toDate());

  }
  
  Future<void> loadLanguage(String language) async {
    await db.collection("languages").where("language" ,isEqualTo: language).get()
        .then((QuerySnapshot qs) => {loadLanguageAssist(qs)} );
  }
  
  loadLanguageAssist(QuerySnapshot<Object?> qs) {
    var i = qs.docs.first.data() as Map<String, dynamic>;
    globals.languageMap = i["languageMap"] as  Map<String, dynamic>;
  }

  Future<void> allLanguageLoad() async {
    await db.collection("languages").where("toList" ,isEqualTo: true).get()
        .then((QuerySnapshot qs) => {allLanguageLoadAssist(qs)} );
  }

  void allLanguageLoadAssist(QuerySnapshot<Object?> qs){
    for (var i in qs.docs)
    {
      var data =i.data() as Map;
      globals.allLanguage.add(data["language"].toString());

    }
  }
  
  Future<void> loadDate(DateTime previousNtpTime) async {
    if (globals.dailyDeckCompleted){
      DateTime ntpTime = await NTP.now();
     //print(ntpTime);
     //print(previousNtpTime);

    if(previousNtpTime.year < ntpTime.year ||
       previousNtpTime.month < ntpTime.month ||
       previousNtpTime.day < ntpTime.day )
      {
        globals.dailyDeckCompleted = false;
                
        await db.collection("users").doc(globals.UID).update(
              {"previusDate"       : ntpTime,
               "dailyDeckCompleted": false});
      }
    }
    






    
  }
  
  
}