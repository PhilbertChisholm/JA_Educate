import 'dart:convert';

import 'package:JA_Educate/Content/Filing/persistentData.dart';
import 'package:JA_Educate/Entities/user.dart';
import 'package:JA_Educate/Services/current_user.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:JA_Educate/Services/shared/function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget{
  final Users user;
  final PersistentData persistentData;
  Setting({Key key, @required this.user, this.persistentData}) : super(key : key);
  @override
  form createState() {
    return form();
}
}
Users currentUser;
PersistentData _persistenceData;

class form extends State<Setting>{
  bool isEnable = false;
  List<String> rating = ["Very Poor", " Poor", "Average", "Good", "Very Good"];
  int choosenIndex;
  String isExpert;
  bool show = false;
  int barColor =0xFF00cc33;
  int iconOne = 0xFF18D191;
  int iconTwo = 0xFFFFFFFF;

  @override
  Widget build(BuildContext context) {

    _persistenceData = widget.persistentData;
    if(_persistenceData != null)
    {
      barColor = int.parse(_persistenceData.getBarColor);
      iconOne = int.parse(_persistenceData.getIconColorOne);
      iconTwo = int.parse(_persistenceData.getIconColorTwo);

    }

    Users registerUser = widget.user;
    var firstNameController = new TextEditingController();
    var lastNameController = new TextEditingController();
    var contactController = new TextEditingController();
    var addressController = new TextEditingController();

    Widget additionalInfoForm()
    {
      return Form(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: TextFormField(
                maxLines: 1,
                initialValue: registerUser.getFirstName??null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  hintText: 'first name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      firstNameController.clear();
                    },),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
                onChanged: (String value) {
                  if(!value.isEmpty)
                    {registerUser.setFirstname = value;}
                },

              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: TextFormField(
                maxLines: 1,
                initialValue: registerUser.getLastName??null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'last name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      lastNameController.clear();
                    },),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
                onChanged: (String value) {
                  if(!value.isEmpty)
                  {registerUser.setLastname = value;}
                },

              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: TextFormField(
                maxLines: 1,
                initialValue: registerUser.getContact??null,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: 'Tele',
                  hintText: '(876)888-8888',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      contactController.clear();
                    },),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
                onChanged: (String value) {
                  if(!value.isEmpty)
                  {registerUser.setContact = value;}
                },

              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: TextFormField(
                maxLines: 1,
                initialValue: registerUser.getAdress??null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'home address',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      addressController.clear();
                    },),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
                onChanged: (String value) {
                  if(!value.isEmpty)
                  {registerUser.setAddress = value;}
                },

              ),
            ),


          ],
        ),
      );
    }
    return StreamBuilder<List<Users>>(
      stream: DatabaseService().users,
      builder: (context, snapshot) {
        if(registerUser == null)
        for(var data in snapshot.data){
          if (data.getUserID == _persistenceData.getUid)
            {
              registerUser = data;
              currentUser =data;
              break;
            }
        }
        else{ currentUser = registerUser;}
        return Scaffold(
          appBar: AppBar(
            title: Text("Settings", style: TextStyle(fontSize: 16),),

            backgroundColor: Color(barColor),
            iconTheme: IconThemeData(color: Color(iconTwo),),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),

              child:
                Form(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children:<Widget> [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text("Rate this Application"),
                         Slider(
                           value: (choosenIndex ?? 1).toDouble(),
                           activeColor: Colors.green,
                           inactiveColor: Colors.green[100],
                           min: 1,
                           max: 4,
                           divisions: 4,
                           onChanged: (val){
                             setState(() {
                               choosenIndex = val.toInt();
                               DatabaseService().updateRatings(registerUser.getUserID, rating[choosenIndex]);
                             });
                           },
                         ),
                            Center(child: Text(rating[choosenIndex??1]),),
                            SizedBox(height: 20,),
                            Card(elevation: 5,
                            child: Column(
                              children: [
                                Text("Want to be an Knowledge Expert:", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14), textAlign: TextAlign.left,),
                                Text("Email us at pchisholm@stu.ncu.edu.jm with your personal biographic along with adequate verification for the information provided", style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),

                                Text("Verification methods:\n"
                                    "1. Certified copies of cerfication\n"
                                    "2. Character reference", textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                              ],
                            ),),

                          ],
                        ),
                      ),
                      Padding(
                        //alignment: Alignment.center,
                        padding: const EdgeInsets.only(top:10, bottom: 10 ),
                        child: Text("PROFILE", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, decoration: TextDecoration.overline), textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children:<Widget> [
                            Checkbox(
                              value: isEnable,
                              onChanged: (bool value){
                                setState(() {
                                  isEnable = value;
                                });

                              } ,
                            ),
                            Text("Edit Profile"),
                          ],
                        ),
                      ),
                      //Column(crossAxisAlignment: CrossAxisAlignment.center,
                        //children:<Widget> [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                children: [

                                     Expanded(
                                      child: TextFormField(
                                       // controller: TextEditingController(text:),
                                        enabled: isEnable,
                                        keyboardType: TextInputType.text,
                                        initialValue: registerUser.getUsername == null ? _persistenceData.getUsername: registerUser.getUsername,
                                        onChanged: (String value){
                                          registerUser.setUsername =value;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Please enter new username';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: (){
                                        DatabaseService().updateUserData(registerUser);
                                      },
                                    ),

                                ],
                              ),
                          ),

                        //],
                      //),

                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                            children:<Widget> [
                                 Expanded(
                                  child: TextFormField(
                                    // controller: TextEditingController(text:),
                                    enabled: isEnable,
                                    keyboardType: TextInputType.text,
                                    onChanged: (String value){
                                      registerUser.setPassword = value;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      hintText: '*******',//pass user name at s
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Please enter new username';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: (){
                                  setState(() {
                                    DatabaseService().updateUserData(registerUser);
                                  });
                                },

                              ),
                            ],
                          ),
                       ),
                      FlatButton.icon(onPressed: ()=> setState(()=>show = !show ),
                          icon: Icon(show ? Icons.keyboard_arrow_down: Icons.keyboard_arrow_up,),
                          label: Text("Add more info")),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: show ? additionalInfoForm(): null,
                      ),
                      SizedBox(height: 15,),
                      Text("THEME", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, decoration: TextDecoration.overline), textAlign: TextAlign.center,),
                      Container(
                        alignment: Alignment.centerLeft,
                          child: Text("Change theme:", style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,)),
                      Radiobutton()
                      // Edit profile(change password, username)
                      //theme change

                    ],
                  ),
                ),
            ),
          ),
        );
      }
    );
  }
}

class Radiobutton extends StatefulWidget {
  @override
  RadioButtonWidget createState() => RadioButtonWidget();
}

class RadioButtonWidget extends State {

  String radioItem = '';

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        RadioListTile(
          groupValue: radioItem,
          title: Text('Default theme'),
          value: 'default',
          onChanged: (String val) {
            setState(() {
              radioItem = val;
              PersistentData persis = PersistentData(
                  iconColorTwo: '0xFFFFFFFF; ',//white
                  iconColorOne: '0xFF18D191',
                  barColor: '0xFF00cc33',
                  username: currentUser.getUsername,
                  isAdmin: currentUser.getIsAdmin,
                  isExpert: currentUser.getIsExpert,
                  uid: currentUser.getUserID,
                Email: currentUser.getEmail
              );
              Functions().saveData(persis);
              _persistenceData = persis;
            });
          },
        ),

        RadioListTile(
          groupValue: radioItem,
          title: Text('Dark theme'),
          value: 'dark',
          onChanged: (String val) {
            setState(() {
    PersistentData persis = PersistentData(
    iconColorTwo: '0xFF18D191',
    iconColorOne: '0xFFFFFFFF',
    barColor: '0xFF000000',
    username: currentUser.getUsername,
    isAdmin: currentUser.getIsAdmin,
    isExpert: currentUser.getIsExpert,
    uid: currentUser.getUserID,
        Email: currentUser.getEmail
    );
    Functions().saveData(persis);

    _persistenceData = persis;
              radioItem = val;
            });
          },
        ),

        //Text('$radioItem', style: TextStyle(fontSize: 23),)

      ],
    );
  }
}