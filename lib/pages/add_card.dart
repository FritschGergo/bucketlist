import 'package:bucketlist/loadData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;


class add_card extends StatefulWidget {

  @override
  _add_cardState createState() => _add_cardState();
}

class _add_cardState extends State<add_card> 
{
  FirebaseFirestore db = FirebaseFirestore.instance;

   final TextEditingController _textEditingController =
      TextEditingController();

  String _inputText = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _onSubmitPressed() async {
    String myHost = "hostReview";
    String myGuest = "guestReview";
    if(globals.host == 2)
    {
      myHost = "guestReview";
      myGuest = "hostReview";
    }

    Map<String , dynamic> MyMap = {
      "toList" : true ,
      globals.language : _textEditingController.text,
      "list" : "BucketList" ,
      "level": 0,
      "deck": "Own deck",
      myHost: 1,
      myGuest: 0,
        
       };

    await db.collection("users").doc(globals.UID).collection("savedCards").add(MyMap);
    LoadMyData().loadCards().then((value) => Navigator.of(context).pop());
  
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your own card'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Enter your text',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _onSubmitPressed,
              child: Text('Submit'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Input Text:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _inputText,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
