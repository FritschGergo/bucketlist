import 'package:bucketlist/auth.dart';
import 'package:bucketlist/loadData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;
import 'add_partner.dart';
import 'erarnToken.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;


  final User? user = Auth().correntUser;
  late TextEditingController textEditingController = TextEditingController();
  

 
  

  Future<void> signOut() async {
    globals.host = 0;           
    globals.inprogress = false;
    globals.GuestUID = "";
    globals.UID = "";
    globals.HisNinckName = "";
    globals.HerNinckName = "";
    globals.currentDeck = {};
    globals.UsersCards = [];
    globals.GlobalCards = [];
    globals.ownedDeck = [];
    globals.newDeck = [];
    globals.currentCardID = "";
    globals.token = 0;
    globals.language = "english";
    globals.languageMap = {};
    globals.allLanguage = [];
    Auth().signOut();
  }

  Future<void> addPartner()
  async {
    await Navigator.of(context).
        push( MaterialPageRoute(builder: (context) => add_partner())).then((value) => setState(() {
          
        },));
  }
  

  Future<void> copyUid() async {
    await Clipboard.setData(ClipboardData(text: user!.uid));
    AlertDialog(content: Text("copied ID"),);
  }

   void _ernToken()
   {
      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  earnToken()),
                  );
  }
  int myIndex()
  {
    for(int i = 0; i < globals.allLanguage.length; i++)
    {
      if(globals.language == globals.allLanguage[i])
      {
        return i;
      }
    }
    return 0;
  }

  languagPick() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        width: double.infinity,
        height: 250,
        child: CupertinoPicker(
          backgroundColor: Colors.black.withOpacity(0.5),
          scrollController: FixedExtentScrollController(initialItem: myIndex()),
          onSelectedItemChanged: (int value) async {
            globals.language = globals.allLanguage[value];
              await db.collection("users").doc(globals.UID).update({
              "language" : globals.allLanguage[value],                                                 //frisíté!
              }); 
              LoadMyData().loadLanguage(globals.language);
            setState(() {
              
            });
          },
          itemExtent: 40, // Ezt állítsd az elemek magasságának megfelelően
          children: List<Widget>.generate(globals.allLanguage.length, (index) {
            return Text(
              globals.allLanguage[index],
              style: TextStyle(fontSize: 20,
                  color: Colors.white),
            // Itt állítsd a szöveg stílusát
            );
          }),
        ),
      ),
    );
    }

  void inputDialog(bool isPartner)
  {
    if((globals.host == 1 && !isPartner) || (globals.host == 2 && isPartner))
    {
      _showTextInputDialog(true);
    }
    else{
      _showTextInputDialog(false);
    }
  }

  String nicknameOutput(bool isPartner)
  {
    if((globals.host == 1 && !isPartner) || (globals.host == 2 && isPartner))
    {
      return globals.HisNinckName;
    }
    return globals.HerNinckName;
  }
  



  void _showTextInputDialog(bool isHe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nick name:'),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: isHe? globals.HisNinckName : globals.HerNinckName),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Cancle'),
            ),
            ElevatedButton(
              onPressed: () async {
                String word = textEditingController.text;
                isHe? globals.HisNinckName = word : globals.HerNinckName = word;
                await db.collection("users").doc(globals.UID).update({
                isHe? "HisNinckName" : "HerNinckName" : word
                                                         //frisíté!
              });
                textEditingController.clear();
                setState(() {
                  
                });
                Navigator.of(context).pop(); // Bezárás
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void deletePartner() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure!?\nAll your data will be deleted!!\nAll cards and token as well!!'),
          actions: [
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.pop(context);
                deletePartnerSecond();
    
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  void deletePartnerSecond() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SURE?!',
          style: TextStyle(fontSize: 50)),
          actions: [
            TextButton(
              child: Text('DELETE'),
              onPressed: () async {
                  QuerySnapshot querySnapshot = await db.collection("users").doc(globals.UID).collection("savedCards").get();
                      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
                        await docSnapshot.reference.delete();  
                  } 
                await db.collection("users").doc(globals.UID).delete().then((value) async =>
                 await db.collection("users").doc(globals.GuestUID).delete().then((value) =>
                  signOut()));   
                  
                
              },
              
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

 

  


  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            backgroundColor: globals.myPrimaryColor,
            toolbarHeight: 50,
            title: Text("Profile ${user!.email}"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  signOut();
                },
              ),
            ],
        ),

        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: ListView(
            children:[
             CustomListItem(icon: Icons.attach_money_sharp, title: "Your tokens", subtitle: globals.token.toString() ,onTap: _ernToken),
             CustomListItem(icon: Icons.money_sharp, title: "Buy mor token", subtitle: "", onTap: _ernToken),
             CustomListItem(icon: Icons.person_add_alt_1_outlined, title: "Add your partner", subtitle: "", onTap: addPartner),
             CustomListItem(icon: Icons.person, title: "Copy your ID", subtitle: "", onTap: copyUid),
             CustomListItem(icon: Icons.person_outline, title: "Partners nickname", subtitle: nicknameOutput(true), onTap:() => inputDialog(true)),
             CustomListItem(icon: Icons.person_outline, title: "Your nickname", subtitle: nicknameOutput(false), onTap:() =>  inputDialog(false)),
             CustomListItem(icon: Icons.language, title: "Select language", subtitle: globals.language, onTap: languagPick),
             CustomListItem(icon: Icons.person_off_outlined, title: "Delete partner", subtitle: "delete all cards as well", onTap: deletePartner)

            ]
            
            
            
            

          )
        )
    );
     
  }

  
}

class CustomListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  CustomListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return 
      Card(
        
        child: ListTile(
          leading: Icon(icon, color: Colors.white,), // Az ikon a lista elején jelenik meg
          title: Text(title, style: TextStyle( color: Colors.white)),
          onTap: onTap,
          trailing: Text(subtitle, style: TextStyle( color: Colors.white),
            ),
          
        ),
        color: globals.myBackgroundColor,
      
    );
  }
}



