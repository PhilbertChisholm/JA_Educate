import 'package:flutter/cupertino.dart';

class Content {
  String contentID;
  String typeID;
  String userID;
  String totalVerifications;
  String description;
  String author;
  String datePublish;
  String dateAdded;
  String content;
  String URL;
  String title;
  String isVerified;


  String get getContentID => contentID;
  String get getUserID => userID;
  String get getTypeID => typeID;
  String get getTotalVerifications => totalVerifications;
  String get getDescription => description;
  String get getAuthor => author;
  String get getDatePublish => datePublish;
  String get getDateAdded => dateAdded;
  String get getURL => URL;
  String get getTitle => title;
  String get getIsVerified => isVerified;
  String get getContent => content;

  void set setTotalVerifications(String number){
    totalVerifications = number;
  }
  void set setVerified(String verified)
  {
    isVerified = verified;
  }
  Content({this.contentID, this.typeID, this.userID, this.totalVerifications, this.description,
      this.author, this.datePublish, this.dateAdded, this.URL, this.title, this.isVerified, this.content});
}