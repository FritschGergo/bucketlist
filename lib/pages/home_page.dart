// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:bucketlist/pages/list_page.dart';
import 'package:bucketlist/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:bucketlist/pages/home2_page.dart';
import 'package:bucketlist/pages/message_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  late TabController _controller;

  @override
  void initState(){
    _controller = TabController(length: 4, vsync: this);
  } 

  @override 
  void dispose(){
    _controller.dispose();
    super.dispose();
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
          
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(20),
        child: DefaultTabController(                         
          length: 4,
          child: TabBar(
            controller: _controller,
            unselectedLabelColor: Colors.black,
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              Tab(
                icon: Icon(Icons.home),
               ),
               Tab(
                 icon: Icon(Icons.list),
               ),
               Tab(
                 icon: Icon(Icons.chat),
               ),
               Tab(
                 icon: Icon(Icons.person),
               ),
              ],
            ),
            )
          ),
        ),
        body: TabBarView(
            children: [
            Home2Page(),
            listPage(),
            MessagePage(),
            ProfilePage(),
            

          ],
          controller: _controller,
        ),


      );
    
  }
}



