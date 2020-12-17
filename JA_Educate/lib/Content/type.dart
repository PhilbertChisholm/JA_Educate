import 'package:flutter/cupertino.dart';

class Type{
  String typeID;
  String userID;
  String name;
  String description;
  String dateCreated;

  String get getTypeID => typeID;
  String get getuserID => userID;
  String get getName => name;
  String get getDescription => description;
  String get getDateCreated => dateCreated;
  Type(@ required this.typeID, @required this.userID, @ required this.name, @ required this.description, @required this.dateCreated);
}