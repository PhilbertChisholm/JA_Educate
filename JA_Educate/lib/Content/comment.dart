import 'package:flutter/cupertino.dart';

class Comment {
  String ID;
  String userID;
  String contentID;
  String category;
  String comment;

  String get getId => ID;
  String get getuserID => userID;
  String get getContentID => contentID;
  String get getCategory => category;
  String get getComment => comment;

  Comment({ this.ID, @required this.userID, @required this.contentID, @required this.category, @required this.comment});
}