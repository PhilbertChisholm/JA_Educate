import 'package:flutter/cupertino.dart';

class Log{
  String logID;
  String contentID;
  String userID;
  String description;
  String date;

  String get getLogID => logID;
  String get getContentID => contentID;
  String get getUserID => userID;
  String get getDescription => description;
  String get getDate => date;

  Log(@ required this.logID, @ required this.contentID, @ required this.userID,  @ required this.description, @required this.date);
}