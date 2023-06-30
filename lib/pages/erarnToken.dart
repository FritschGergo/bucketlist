import 'package:bucketlist/pages/review_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class earnToken extends StatefulWidget {
  const earnToken({super.key});

  @override
  State<earnToken> createState() => _earnToken();
}


class _earnToken extends State<earnToken>
    with TickerProviderStateMixin {

  FirebaseFirestore db = FirebaseFirestore.instance;
    
  void buy(int price) async {
    String myToken = "hostToken";
    if(globals.host == 2)
    {
      myToken = "guestToken";
    }
    await db.collection("users").doc(globals.UID).update({myToken : FieldValue.increment(price)});
    globals.token = globals.token + price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            CardItem(
              title: '1 token 1\$',
              onTap: () {
                buy(1);
                Navigator.pop(context);
              },
            ),
            CardItem(
              title: '5 token 3\$',
              onTap: () {
                buy(5);
                Navigator.pop(context);
              },
            ),
            CardItem(
              title: '10 token 5\$',
              onTap: () {
                buy(10);
                Navigator.pop(context);
              },
            ),
            CardItem(
              title: 'Invite your partner or friends for 3token',
              onTap: () {
                // Handle onTap for Card 4
                Navigator.pop(context);
              },
            ),
            CardItem(
              title: 'Share us your card ideas(5 ideas for 1 token)',
              onTap: () {
                // Handle onTap for Card 5
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
 Widget CardItem({required String title, required Null Function() onTap}) {
  return Card(
    
    shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
    margin:EdgeInsets.only(right: 20, left: 20 , top: 10),
      child: InkWell( 
        onTap: onTap,
        child :SizedBox(
        height: 100,
        child: Center(
          child: Text(title),
        
        ),
      )
      
    )
  );

 }
  
  
}