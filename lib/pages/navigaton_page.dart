import 'package:bucketlist/loadData.dart';
import 'package:bucketlist/pages/list_page.dart';
import 'package:bucketlist/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:bucketlist/pages/home_page.dart';
import 'package:bucketlist/pages/message_page.dart';
import '../globals.dart' as globals;


class MyNavigationPage extends StatefulWidget {
  const MyNavigationPage({super.key});

  @override
  State<MyNavigationPage> createState() => _MyNavigationPageState();
}

class _MyNavigationPageState extends State<MyNavigationPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (globals.host <= 0 || globals.inprogress) {
      if (!globals.inprogress) {
        LoadMyData().loadGlobals();
         globals.inprogress = true;
      }
      Future.delayed(const Duration(milliseconds: 100)).then((value) => setState(() {}));
      //return const CircularProgressIndicator();
    }
    if (globals.inprogress)
    {

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 184,29,31),
        body: Center(child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 300, height: 300),
              const SizedBox(height: 20),
              const Text(
                "Bucket List",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.white,),
              
            ]
          ) ,
        )
       
      );
      
      
      
      
    
    }

    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            children: [
              HomePage(),
              listPage(),
              MessagePage(),
              ProfilePage(),
            ],
            controller: _controller,
            
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: DefaultTabController(
                  length: 4,
                  child: TabBar(
                    controller: _controller,
                    unselectedLabelColor: Colors.black,
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
                    indicatorColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
