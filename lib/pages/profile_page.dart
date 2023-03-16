import 'package:bucketlist/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final User? user = Auth().correntUser;

  Future<void> signOut() async {
    await Auth().signOut();

  }

   Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut,
     child: const Text('Sign Out'));
      
    
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _userUid(),
              _signOutButton()
            ],
          )
          ,)

    );

  }

}



