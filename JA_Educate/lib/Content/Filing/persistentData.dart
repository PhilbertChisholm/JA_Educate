import 'dart:core';

class PersistentData{
  String barColor;
  String iconColorOne;
  String iconColorTwo;
  String username;
  String uid;
  String isExpert;
  String isAdmin;
  String Email;

  String get getBarColor => this.barColor;
  String get getIconColorOne => this.iconColorOne;
  String get getIconColorTwo => this.iconColorTwo;
  String get getUsername => this.username;
  String get getUid => this.uid;
  String get getIsExpert => this.isExpert;
  String get getIsAdmin => this.isAdmin;
  String get getEmail => this.Email;
  PersistentData({this.uid, this.isExpert, this.isAdmin, this.username, this.barColor,this.iconColorOne, this.iconColorTwo, this.Email});

PersistentData.fromMap(dynamic map):
      this.uid = map['uid'] == "" ? "" : map['uid'] as String,
      this.isExpert = map['isExpert'] == null ? null : map['isExpert'] as String,
      this.isAdmin = map['isAdmin'] == null ? null : map['isAdmin'] as String,
      this.username = map['username'] == null ? null : map['username'] as String,
      this.Email = map['Email'] == null ? null : map['Email'] as String,
      this.barColor = map['barColor'] == null ? null : map['barColor'] as String,
      this.iconColorOne = map['iconColorOne'] == null ? null : map['iconColorOne'] as String,
      this.iconColorTwo = map['iconColorTwo'] == null ? null : map['iconColorTwo'] as String;

Map<String, String> toMap(){
  return {
    'uid': this.uid,
    'isExpert': this.isExpert,
    'isAdmin': this.isAdmin,
    'Email': this.Email,
    'username': this.username,
    'barColor': this.barColor,
    'iconColorOne': this.iconColorOne,
    'iconColorTwo': this.iconColorTwo,
  };
}
}