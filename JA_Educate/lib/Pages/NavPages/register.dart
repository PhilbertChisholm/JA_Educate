import 'package:JA_Educate/Entities/user.dart';
import 'package:JA_Educate/Services/authentication.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:JA_Educate/Services/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  @override
  form createState() {
    return form();
  }
}

class form extends State<Register> {
  final Authentication _auth = Authentication();
  final _regFormKey = GlobalKey<FormState>();

  String email;
  String password;
  String username;
  String error = "";
  bool verified = false;
  bool isEnable = false;
  bool ischecked = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(0xFF18D191)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child:
          isLoading? Loading():Form(
                key: _regFormKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
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
                                  width:100,
                                  decoration: BoxDecoration(border: Border.all(color: Color(0xFF18D191), style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                  ),
                                  child: Center(
                                    child: Text('Register',
                                        textAlign: TextAlign.center, style: GoogleFonts.greatVibes(fontSize: 24, )),
                                  ),),),],),
                        ),
                       // Center(heightFactor: 2,child: Text(" Create an account"),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: TextFormField(
                                //controller: titleController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  hintText: 'John',
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  username = value;
                                }),
                          ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                onChanged: (String value) {
                                  email = value;
                                }),
                          ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: TextFormField(
                              //controller: titleController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'e.g abc12345 (at least 7 characters)',
                              ),
                              validator: (String value) {
                                if (value.isEmpty || value.length < 7) {
                                  return 'Please enter valid password';
                                }
                                return null;
                              },
                              onChanged: (String value) {
                                password = value;
                              },
                            ),
                          ),

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child:
                        Row(
                              children: [
                                Expanded(
                                  //width: 270,
                                  child: TextFormField(
                                    //controller: titleController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      hintText: 'e.g abc12345',
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty || value != password ) {
                                        return 'Please confirm password';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == password && !password.isEmpty) {
                                          verified = true;
                                        }
                                        else
                                          {verified = false;}
                                      });
                                    },
                                  ),
                                ),
                                 Icon(
                                      Icons.check_circle,
                                      color: !verified ? Colors.red : Colors.green,
                                    ),
                              ],
                            ),
                ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Row(children: [
                            //width:100,

                            Checkbox(
                              value: ischecked,
                              checkColor: Colors.green,
                              onChanged: (bool value) {
                                setState((){
                                ischecked = value;// create keep logged in function
                                if (value) {
                                } else {}
                                });
                              },
                            ),
                            Expanded(
                              child: Container(
                                child: Text('Keep me logged in'),
                              ),
                            ),
                          ]),
                        ),
                        RaisedButton(
                            onPressed: () async {
                              if(_regFormKey.currentState.validate())
                                {
                                  print (email);
                                  setState(()=> isLoading = true);
                                  dynamic result = await _auth.registerAccount(email.trim(), password.trim());
                                  if(result == null)
                                    {
                                      setState(() {
                                        print("result is null");
                                        error = 'could not register, invalid email address';
                                        isLoading =false;
                                        verified = false;
                                      });
                                    }
                                  else
                                    {
                                    setState(() {
                                      isLoading =false;
                                      Users user = Users.user(
                                        firstName: "",
                                          LastName: "",
                                          userID: result.toString(),
                                          username: username,
                                          password: password.trim(),
                                          dateCreated: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                          enabled: 'true',
                                      email: this.email,
                                        address: "",
                                        bio: "",
                                        contact: "",
                                        isAdmin: 'false',
                                        isExpert: 'false',
                                        validation: ""
                                       );
                                      print(user.toString());

                                      DatabaseService().updateUserData(user);
                                      error = 'Successful!';
                                    });
                                    }

                                }
                            },
                            color: Colors.green,
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        SizedBox(height: 12,),
                        Text(
                          error, style: TextStyle(color: Colors.red, fontSize: 14 ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
