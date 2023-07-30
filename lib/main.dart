import 'package:bucketlist/globals.dart';
import 'package:flutter/material.dart';
import 'package:bucketlist/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      "pk_test_51NVCVXDjS8bNiTGY72jyZqfVPPd4kaZDxDbQ8bJDjmbiGl0IvpCuqFT33MQg4HPhpcNVbdKxcWfpPAa4jtF0iWog00FuQhWh5T";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: globals.myPrimaryColor,
        // scaffoldBackgroundColor: globals.myBackgroundColor,
       
      ),
      darkTheme: ThemeData.dark(),
      

      home: const WidgetTree(),
    );
  }
}
