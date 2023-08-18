import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import '../globals.dart' as globals;

import '../auth.dart';


class ideaPage extends StatefulWidget {
  const ideaPage({super.key});

  @override
  State<ideaPage> createState() => _ideaPage();
}


class _ideaPage extends State<ideaPage>
    with TickerProviderStateMixin {
      List<String> textEntries = ['', '', '', '', ''];
  bool canSubmit = false;
  static const String text = "We only accept coherent and meaningful ideas!\nYou need to write 5 different ideas.\nIt must be at least 10 characters long!\nYou can only earn tokens with this once per day!\nWe can use your ideas for creating new decks!\nIf you don't comply with points 1 and 2, this function will be disabled for you!";
  final User? user = Auth().correntUser;
  FirebaseFirestore db = FirebaseFirestore.instance;


  void checkSubmitAvailability() {
    bool allValid = true;
    for (String entry in textEntries) {
      if (entry.length < 10) {
        allValid = false;
        break;
      }
    }
    setState(() {
      canSubmit = allValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Ideas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < 5; i++)
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    textEntries[i] = value;
                  });
                  checkSubmitAvailability();
                },
                maxLines: null,
                decoration: InputDecoration(labelText: 'Idea ${i + 1}'),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: canSubmit
                  ? () {
                      showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Conditions'),
                          content: Text(text),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                DateTime ntpTime = await NTP.now();
                                await db.collection("users").doc(user?.uid).update({"token" : FieldValue.increment(1),
                                                                                    "lastIdea" : ntpTime});
                                globals.token = globals.token + 1;
                                await db.collection("ideas").add({"user" : user?.uid,
                                                                  "isWatched" :  false,
                                                                  "dateTime" :  ntpTime,
                                                                  "idea 1" : textEntries[0],
                                                                  "idea 2" : textEntries[1],
                                                                  "idea 3" : textEntries[2],
                                                                  "idea 4" : textEntries[3],
                                                                  "idea 5" : textEntries[4],
                                                                  });

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('I understand and accept the terms!'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancle'),
                            ),
                          ],
                        );
                      },
                    );
                      
                    }
                  : null,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the informational dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Conditions'),
                content: Text(text),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.info),
      ),
    );
  }

  

}