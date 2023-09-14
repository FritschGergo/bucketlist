library my_prj.globals;

import 'package:flutter/material.dart';

int host = 0;                 // 0(idk) 1(host) 2(guest) 3(ready to pair)
bool inprogress = false;
String GuestUID = "";
String UID = "";
String HisNinckName = "set ninck name";
String HerNinckName = "set ninck name";
Map currentDeck = {};
List<Map<String, dynamic>> UsersCards = [];
List<Map<String, dynamic>> GlobalCards = [];
List<String> ownedDeck = [];
List<String> newDeck = [];
String currentCardID = "";
int token = 0;
String language = "english";
Map<String, dynamic> languageMap = {};
List<String> allLanguage = [];
bool dailyDeckCompleted = true;
DateTime lastIdea = DateTime(2000);
bool bannedFromIdeas = true;


const Color myPrimaryColor =  Color.fromARGB(255, 191, 27, 27);
const Color mySecondaryColor =  Color.fromARGB(255, 115, 10, 10);
const Color myTertiaryColor =  Color.fromARGB(255,64, 1, 1);
const Color myBackgroundColor =  Color.fromARGB(255, 74, 74, 74);


