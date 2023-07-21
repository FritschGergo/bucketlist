import 'dart:convert';

import 'package:bucketlist/pages/review_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card ;
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;

class earnToken extends StatefulWidget {
  const earnToken({super.key});

  @override
  State<earnToken> createState() => _earnToken();
}


class _earnToken extends State<earnToken>
    with TickerProviderStateMixin {

  FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, dynamic>? paymentIntent;
    
  void buy(int price) async {
    
    
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
  ) ;
 }
 

 Future<void> makePayment(String myValue) async {
    try {
      paymentIntent = await createPaymentIntent(myValue, 'EUR');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(myValue);
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet(String myValue) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
        sucessfulPaymant(myValue);
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  void sucessfulPaymant(String myValue) async {
    int newToken = 1;
    if (myValue == "3")
    {
      newToken = 5;
    }else if(myValue == "5")
    {
      newToken = 10;
    }

    String myToken = "hostToken";
    if(globals.host == 2)
    {
      myToken = "guestToken";
    }
    await db.collection("users").doc(globals.UID).update({myToken : FieldValue.increment(newToken)});
    globals.token = globals.token + newToken;

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
                makePayment("1");
                
              },
            ),
            CardItem(
              title: '5 token 3\$',
              onTap: () {
                makePayment("3");
                
              },
            ),
            CardItem(
              title: '10 token 5\$',
              onTap: () {
                makePayment("5");
                
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
  
}