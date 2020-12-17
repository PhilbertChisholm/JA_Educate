import 'dart:convert';

import 'package:JA_Educate/Content/Filing/persistentData.dart';
import 'package:JA_Educate/Entities/user.dart';
import 'package:JA_Educate/Pages/NavPages/register.dart';
import 'package:JA_Educate/Services/authentication.dart';
import 'package:JA_Educate/Services/current_user.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:JA_Educate/Services/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
@override
LoginForm createState() {
  return LoginForm();
}
}

class LoginForm extends State<Login> {

  final _loginFormKey = GlobalKey<FormState>();
  final Authentication _auth = Authentication();
  List<Users> userlist;
  String email;
  String uid;
  String password;
  String error = '';
  bool ischecked = false;
  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<Users>>(
      stream: DatabaseService().users,
      builder: (context, snapshot) {
        userlist = snapshot.data ?? null;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Color(0xFF18D191)),
            leading: IconButton(icon: Icon(Icons.close),
              onPressed: (){ Navigator.of(context).pop(null);},
              alignment: Alignment.topLeft,
            ),
            toolbarHeight: 50,
          ),
          body:
               SingleChildScrollView(
                   child: Container(
                      padding: EdgeInsets.all(20),
                      child: isLoading? Loading(): Form(
                            key: _loginFormKey,
                              child: Wrap(
                                        direction: Axis.horizontal,
                                        spacing: 1,
                                        runSpacing: 5,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                const CircleAvatar(backgroundImage: AssetImage("images/loginIcon.jpg"),radius: 75,),
                                                SizedBox(height: 5,),
                                                Card(
                                                  elevation: 10,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                                  ),
                                                  child: Container(
                                                    height: 40,
                                                    width:75,
                                                    decoration: BoxDecoration(border: Border.all(color: Color(0xFF18D191), style: BorderStyle.solid),
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                                    ),
                                                    child: Center(
                                                      child: Text('Login',
                                                        textAlign: TextAlign.center, style: GoogleFonts.greatVibes(fontSize: 24, )),
                                                    ),),),],),
                                          ),


                                              Padding(
                                                padding: EdgeInsets.only(left: 5, right: 5),
                                                child: TextFormField(
                                                  //controller: titleController,
                                                    keyboardType: TextInputType.text,
                                                    decoration: InputDecoration(
                                                      labelText: 'Email',
                                                      hintText: 'e.g ja@mail.com',
                                                    ),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return 'Please enter valid email address';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      email = value;
                                                    }

                                                ),
                                              ),

                                          Padding(
                                              padding: EdgeInsets.only(left: 5, right: 5),
                                              child: TextFormField(
                                                  //controller: titleController,
                                                  keyboardType: TextInputType.text,
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'Password',
                                                  ),
                                                  validator: (String value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter valid password';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    password = value;
                                                  },
                                                ),
                                            ),

                                            Center(
                                              child: RaisedButton(

                                                onPressed: () async {
                                                  if(_loginFormKey.currentState.validate()) {
                                                    setState (()=> isLoading = true);
                                                    dynamic result = await _auth
                                                        .login(
                                                        email.trim(), password.trim());
                                                    if (result == null) {
                                                      setState(() {
                                                        error = "could not log in, invalid email or password";
                                                        isLoading =false;
                                                      });
                                                    }
                                                    else{
                                                      setState((){
                                                        uid = result.toString();
                                                        Users user = CurrentUser().getCurrentUSer(uid, userlist);

                                                        if(ischecked)
                                                        {
                                                          PersistentData persis = PersistentData(
                                                            iconColorTwo: '0xFFFFFFFF; ',//white
                                                            iconColorOne: '0xFF18D191',
                                                            barColor: '0xFF00cc33',
                                                            username: user.getUsername,
                                                            isAdmin: user.getIsAdmin,
                                                            isExpert: user.getIsExpert,
                                                            uid: user.getUserID
                                                          );
                                                        }
                                                        isLoading =false;
                                                        Navigator.pop(context, user);
                                                      });
                                                    }

                                                  }
                                                  else
                                                  {
                                                    error = "could not sign in";
                                                    isLoading =false;
                                                  }

                                                },
                                                color: Color(0xFF18D191),
                                                child: Text('Sign in'),

                                              ),
                                            ),

                                          SizedBox(height: 1,),
                                          Text(
                                            error, style: TextStyle(color: Colors.red, fontSize: 14, ),textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                            child:
                                            Center(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    //width:100,

                                                    Checkbox(
                                                      value: ischecked,
                                                      checkColor: Colors.green,
                                                      onChanged: (bool value) {
                                                        setState((){
                                                          ischecked = value;
                                                        });
                                                      },
                                                    ),
                                                    Expanded(child:
                                                    Container(
                                                      child:
                                                      Text('Remember me'),
                                                    ),),
                                                  ]
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Row(children: <Widget>[
                                              Text("Don't have an Account"),
                                              FlatButton(child: Text("Sign Up"),
                                                onPressed: () {
                                                  Navigator.push<MaterialPageRoute>(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Register()));
                                                  //Navigator.pop(context);
                                                },),
                                            ],),
                                          ),
                                        ],),
                            ),
              ),
                 ),
        );
      }
    );
  }
}