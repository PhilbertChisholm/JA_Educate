import 'package:flutter/cupertino.dart';

class Users{
  String userID;
  String enabled = "true";
  String firstName = "";
  String LastName = "";
  String email = "";
  String username = "";
  String password = "";
  String dateCreated = "";
  //expert users
  String contact = "";
  String bio = "";
  String validation = "";
  String isExpert = "true";
  // admin users
  String address = "";
  String isAdmin = "true";

  String get getUserID => userID;
  String get getEnabled => enabled;
  String get getFirstName => firstName;
  String get getLastName => LastName;
  String get getEmail => email;
  String get getUsername => username;
  String get getPassword => password;
  String get getDateCreated => dateCreated;
  // expert user get functions
  String get getContact => contact;
  String get getBio => bio;
  String get getValidation => validation;
  String get getIsExpert => isExpert;
  // Admin user get functions
  String get getAdress => address;
  String get getIsAdmin => isAdmin;

  void set setAddress(String value)
  {this.address = value;}

  void set setDateCreated(String value)
  {this.dateCreated = value;}

  void set setValidation(String value)
  {this.validation = value;}

  void set setBio(String value)
  {this.bio = value;}

  void set setContact(String value) => this.contact = value;

  void set setIsExpert(String value)
  {this.isExpert = value;}

  void set setIsAdmin(String value)
  {this.isAdmin = value;}

  void set setEnable(String value)
  {this.enabled = value;}

  void set setFirstname(String value)
  {this.firstName = value;}

  void set setLastname(String value)
  {this.LastName = value;}

  void set setEmail(String value)
  {this.email = value;}

  void set setUsername(String value)
  {this.username = value;}

  void set setPassword(String value)
  {this.password = value;}


  Users(this.userID);
  Users.user({this.userID, this.enabled, this.firstName, this.LastName, this.email,
    this.username, this.password, this.dateCreated, this.isExpert, this.validation, this.bio, this.contact, this.isAdmin, this.address});
}