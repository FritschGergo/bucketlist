import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../globals.dart' as globals;
import '../loadData.dart';

class add_partner extends StatefulWidget {

  @override
  _add_partnerState createState() => _add_partnerState();
}

class _add_partnerState extends State<add_partner> 
{
  String textField1Value = '';
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
    if (textField1Value.isEmpty) {
      MyShowDialog('Please fill in all the text fields.');
      return;
    }

    Map testData;
    Map test2Data;
    db.collection("users").doc(globals.UID).get().
      then((DocumentSnapshot test)  async => {
          db.collection("users").doc(globals.UID).get().
            then((DocumentSnapshot test2)  async => {
              testData = test.data() as Map,
              test2Data = test2.data() as Map,
              if(testData["host"] == 3 || test2Data["host"] == 3)
              {
                if (switchValue == "option1")
                  {
                    globals.host = 2,
                    globals.UID = textField1Value,
                    globals.GuestUID = user!.uid,

                  }else
                  {
                    globals.host = 1,
                    globals.UID = user!.uid,
                    globals.GuestUID =  textField1Value,     
                  },
                  addata().then((value) => Navigator.of(context).pop()),

              }
              else{
                MyShowDialog('Accounts not exist or alread in a pair')
          
              }

          })
      });
       
  }

  Future addata() async {

      await db.collection("users").doc(globals.UID).set({
        "partner" : globals.GuestUID,
        "token" : 1,
        "host" : 1,                // guest= 0(idk) 1(host) 2(guest) 3(ready to pair)
        "HerNinckName" : globals.HerNinckName,
        "HisNinckName" : globals.HisNinckName,
        "language" : "english",
        "dailyDeckCompleted" : false,
        });   
      await db.collection("users").doc(globals.GuestUID).set({
        "partner" : globals.UID,
        "host" : 2,
        "token" : 1,
      });
      globals.token = 1;
      
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

