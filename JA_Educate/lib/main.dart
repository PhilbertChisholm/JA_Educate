import 'dart:convert';
import 'dart:ui';
import 'package:JA_Educate/Content/Filing/persistentData.dart';
import 'package:JA_Educate/Content/comment.dart';
import 'package:JA_Educate/Content/content.dart';
import 'package:JA_Educate/Content/log.dart';
import 'package:JA_Educate/Content/type.dart';
import 'package:JA_Educate/Entities/anonymous_user.dart';
import 'package:JA_Educate/Entities/user.dart';
import 'package:JA_Educate/Pages/NavPages/login.dart';
import 'package:JA_Educate/Pages/add_form.dart';
import 'package:JA_Educate/Pages/home_form.dart';
import 'package:JA_Educate/Pages/NavPages/history.dart';
import 'package:JA_Educate/Pages/NavPages/setting.dart';
import 'package:JA_Educate/Services/authentication.dart';
import 'package:JA_Educate/Services/current_user.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:JA_Educate/Services/shared/function.dart';
import 'package:JA_Educate/Services/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/search_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new MaterialApp(home: MyApp()));
}

String username = "there";
String Email = "";
bool isLoggedIn = false;
bool isExpert = false;
bool isAdmin = false;
final Authentication _auth = Authentication();
//List<Users> userlist;
String uid = "n\a";
Users _user;

class MyApp extends StatefulWidget {
  final Users user;

  MyApp({this.user});

  @override
  mainForm createState() {
    return mainForm();
  }
}

class mainForm extends State<MyApp> {
  int currentPage = 0;
  bool sliver = false;
  int _barColor = 0xFF00cc33;
  int _iconOne = 0xFF18D191;
  int _iconTwo = 0xFFFFFFFF;
  PersistentData persistence;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    persistence = await Functions().loadSharePreferencesData();
    setState(() {});
  }

  //void saveData(){
  //List<String> data = persis.map((item) => json.encode(item.toMap())).toList();
  //_sharedPreferences.setStringList('list', data);
  //}

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    int tabCount = 3;
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    void dispose() {
      super.dispose();
    }

    void _init() {
      if (persistence == null) {
        print("has no data");
        if (_user != null) {
          username = _user.getUsername;
          Email = _user.getEmail;
          isExpert = CurrentUser().isTrue(_user.getIsExpert);
          isAdmin = CurrentUser().isTrue(_user.getIsAdmin);
          uid = _user.getUserID;
          isLoggedIn = true;
        }
      } else {
        print("has data");
        username = persistence.getUsername;
        isExpert = CurrentUser().isTrue(persistence.getIsExpert);
        isAdmin = CurrentUser().isTrue(persistence.getIsAdmin);
        Email = persistence.Email;
        uid = persistence.getUid;
        _barColor = int.parse(persistence.getBarColor);
        _iconOne = int.parse(persistence.getIconColorOne);
        _iconTwo = int.parse(persistence.getIconColorTwo);
        isLoggedIn = true;
      }
    }

    List<Widget> tab = [
      Home(uid: uid),
      Search(uid: uid),
      App(uid: uid, isAdmin: isAdmin, isExpert: isExpert)
    ];
    _init();
    login();
    return MultiProvider(
      providers: [
        StreamProvider<List<Content>>.value(value: DatabaseService().contents),
        StreamProvider<List<Comment>>.value(value: DatabaseService().comments),
        //StreamProvider<List<Users>>.value(value: DatabaseService().users),
        StreamProvider<List<Log>>.value(value: DatabaseService().logs),
        StreamProvider<List<Type>>.value(value: DatabaseService().type),
        StreamProvider<QuerySnapshot>.value(value: DatabaseService().con),
        StreamProvider<Users>.value(value: Authentication().registeredUser),
        StreamProvider<AnonymousUser>.value(value: Authentication().user)
      ],
      child: MaterialApp(
        home: DefaultTabController(
          length: tabCount,
          child: Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              elevation: 1,
              child: !isLoggedIn
                  ? ListView(children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName: Text('Please sign-in'),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Theme.of(context).platform ==
                                  TargetPlatform.android
                              ? Color(_barColor)
                              : Colors.white,
                          child: Text(
                            "User",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("Home"),
                        trailing: Icon(Icons.home_outlined),
                        onTap: () {
                          if (_scaffoldKey.currentState.isDrawerOpen) {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                          setState(() {
                            currentPage = 0;
                            sliver = false;
                            // Navigator.of(context).pop();
                          });
                        },
                      ),
                      ListTile(
                        title: Text("Sign In"),
                        trailing: Icon(Icons.lock_open_outlined),
                        onTap: () async {
                          _user = await Navigator.push<Users>(context,
                              MaterialPageRoute(builder: (context) => Login()));
                          setState(
                            () => _init(),
                          );
                          PersistentData tempPersistence = PersistentData(
                              uid: _user.getUserID,
                              isExpert: _user.isExpert,
                              Email: _user.getEmail,
                              isAdmin: _user.isAdmin,
                              username: _user.username,
                              barColor: _barColor.toString(),
                              iconColorOne: _iconOne.toString(),
                              iconColorTwo: _iconTwo.toString());
                          Functions().saveData(tempPersistence);
                        },
                      ),
                    ])
                  : !isExpert
                      ? ListView(
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              accountName: Text("hey, ${username}"),
                              accountEmail: Text(Email),
                              currentAccountPicture: CircleAvatar(
                                backgroundColor: Theme.of(context).platform ==
                                        TargetPlatform.android
                                    ? Color(_barColor)
                                    : Colors.white,
                                child: Text(
                                  username.substring(0, 1),
                                  style: TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text("Home"),
                              trailing: Icon(Icons.home_outlined),
                              onTap: () {
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                setState(() {
                                  currentPage = 0;
                                  sliver = false;
                                });
                              },
                            ),
                            ListTile(
                              title: Text("Histroy"),
                              trailing: Icon(Icons.history),
                              onTap: () {
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                Navigator.push<MaterialPageRoute>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => History(
                                            uid: uid,
                                            isAdmin: isAdmin,
                                            isExpert: isExpert,
                                            persistenceData: persistence,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text("Settings"),
                              trailing: Icon(Icons.settings),
                              onTap: () async {
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                _user = await Navigator.push<Users>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Setting(
                                            user: _user,
                                            persistentData: persistence,
                                          )),
                                );
                                setState(
                                  () => _init(),
                                );
                              },
                            ),
                            ListTile(
                              title: Text("Sign Out"),
                              trailing: Icon(Icons.lock_outline),
                              onTap: () async {
                                await _auth.logOut();
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                persistence = null;
                                Functions().saveData(persistence);
                                setState(() {
                                  isLoggedIn = false;
                                  username = "";
                                  uid = "";
                                  Email = "";
                                  isExpert = false;
                                  isAdmin = false;
                                  _user = null;
                                  currentPage = 0;
                                });
                              },
                            )
                          ],
                        )
                      : ListView(
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              accountName: Text("hey, ${username}"),
                              accountEmail: Text(Email),
                              currentAccountPicture: CircleAvatar(
                                backgroundColor: Theme.of(context).platform ==
                                        TargetPlatform.android
                                    ? Color(_barColor)
                                    : Colors.white,
                                child: Text(
                                  username.substring(0, 1),
                                  style: TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text("Home"),
                              trailing: Icon(Icons.home_outlined),
                              onTap: () {
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                setState(() {
                                  currentPage = 0;
                                  sliver = false;
                                });
                              },
                            ),
                            ListTile(
                              title: Text("Add Content"),
                              trailing: Icon(Icons.add_circle_outline),
                              onTap: () {
                                setState(() {
                                  currentPage = 2;
                                });
                              },
                            ),
                            ListTile(
                              title: Text("Histroy"),
                              trailing: Icon(Icons.history),
                              onTap: () {
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                Navigator.push<MaterialPageRoute>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => History(
                                            uid: uid,
                                            isAdmin: isAdmin,
                                            isExpert: isExpert,
                                            persistenceData: persistence,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text("Settings"),
                              trailing: Icon(Icons.settings),
                              onTap: () async {
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                _user = await Navigator.push<Users>(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Setting(
                                                user: _user,
                                                persistentData: persistence,
                                              )),
                                    ) ??
                                    _user;
                                setState(
                                  () => _init(),
                                );
                              },
                            ),
                            ListTile(
                              title: Text("Sign Out"),
                              trailing: Icon(Icons.lock_outline),
                              onTap: () async {
                                await _auth.logOut();
                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                }
                                persistence = null;
                                Functions().saveData(persistence);
                                setState(() {
                                  isLoggedIn = false;
                                  username = "";
                                  uid = "";
                                  Email = "";
                                  isExpert = false;
                                  isAdmin = false;
                                  _user = null;
                                });
                              },
                            )
                          ],
                        ),
            ),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                innerBoxIsScrolled = sliver;
                return <Widget>[
                  SliverAppBar(
                    elevation: 2,
                    backgroundColor: Color(_barColor),
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        "Ja Educate",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      background: Image.asset(
                        "images/JamaicanCulture.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentPage = 1;
                            sliver = true;
                          });
                        },
                        icon: Icon(Icons.search),
                      ),
                    ],
                  ),
                ];
              },
              body: Container(
                //padding: EdgeInsets.only(top: 10),
                //margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: currentPage == 0
                          ? tab[currentPage]
                          : currentPage == 1
                              ? tab[currentPage]
                              : tab[2],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void login() async {
  dynamic result;
  if (!isLoggedIn) {
    result = await _auth.signInAnonymous();
    if (result == null && !isLoggedIn) {
      print("error could not log in");
    } else {
      username = 'there\n log in here';
      //print("User id"+result.uid.toString());
    }
  } else {}
}
