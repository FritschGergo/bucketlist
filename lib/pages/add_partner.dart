import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../globals.dart' as globals;

class add_partner extends StatefulWidget {

  @override
  _add_partnerState createState() => _add_partnerState();
}

class _add_partnerState extends State<add_partner> 
{
  String textField1Value = '';
  String textField2Value = '';
  String textField3Value = '';
  String switchValue = 'option1';

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = Auth().correntUser;

  void MyShowDialog(String error){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    
  }


  void _onSubmitButtonPressed() {
    // Perform form validation
    if (textField1Value.isEmpty ||
        textField2Value.isEmpty ||
        textField3Value.isEmpty) {
      MyShowDialog('Please fill in all the text fields.');
      return;
    }
    
    if (switchValue == "option1")
    {
      globals.UID = textField3Value;
      globals.GuestUID = user!.uid;
      globals.HerNinckName = textField2Value;
      globals.HisNinckName = textField1Value;
      
      
    }else
    {
      globals.UID = user!.uid;
      globals.GuestUID =  textField3Value;
      globals.HerNinckName = textField1Value;
      globals.HisNinckName = textField2Value; 
      
    }
    addata();


    
  }

  Future<void> addata() async{

    
    
    db.collection("users").doc(globals.UID).get().
      then((DocumentSnapshot test)  async => {
        if (!test.exists){

          db.collection("users").doc(globals.GuestUID).get().
              then((DocumentSnapshot test)  async => {
                if (!test.exists){



                  await db.collection("users").doc(globals.UID).set({
                    "partner" : globals.GuestUID,
                    "token" : 10,
                    "host" : 1,                // guest= 0(idk) 1(host) 2(guest) 
                    "HerNinckName" : globals.HerNinckName,
                    "HisNinckName" : globals.HisNinckName
                    }),   
                  await db.collection("users").doc(globals.GuestUID).set({
                    "partner" : globals.UID,
                    "host" : 2,
                    }),
                  await db.collection("users").doc(globals.UID).collection("savedDecks").add({"name" : "BucketList"}),
                  await db.collection("users").doc(globals.UID).collection("savedDecks").add({"name" : "HostWishList"}),
                  await db.collection("users").doc(globals.UID).collection("savedDecks").add({"name" : "GuestWishList"}),
                  await db.collection("users").doc(globals.UID).collection("savedDecks").add({"name" : "DoneList"}),
                  await db.collection("users").doc(globals.UID).collection("savedDecks").add({"name" : "IdeasList"}),
                  await db.collection("users").doc(globals.UID).collection("savedDecks").add({"name" : "LaterList"}),
                  await db.collection("users").doc(globals.UID).collection("savedDecks").add({"name" : "DislikeList"}),
                  Navigator.pop(context)
                } 
                else
                {
                  MyShowDialog('Account exist')
                }
          })
        }
        else{
          MyShowDialog('Account exist')
          
        }
        
      }
      
    
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your Partner'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    textField1Value = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Text Field 1 is required';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Your parner nickname",
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    textField2Value = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Text Field 2 is required';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Your nickname",
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    textField3Value = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Text Field 3 is required';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Your Partners UID",
                ),
              ),
              SizedBox(height: 16.0),
              Text('In our relationship, I am the'),
              DropdownButton<String>(
                value: switchValue,
                onChanged: (newValue) {
                  setState(() {
                    switchValue = newValue!;
                  });
                },
                items: const [
                    DropdownMenuItem(
                    value: 'option1',
                    child: Text('Womam'),
                  ),
                  DropdownMenuItem(
                    value: 'option2',
                    child: Text('Man'),
                  ),
                   DropdownMenuItem(
                    value: 'option3',
                    child: Text('Other'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _onSubmitButtonPressed,
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

