library my_prj.globals;

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