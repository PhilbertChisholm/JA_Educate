import 'package:JA_Educate/Entities/user.dart';

class CurrentUser {
  Users getCurrentUSer(String uid, List<Users> users) {
    Users registerUser = new Users.user();
    for (var user in users) {
      if (uid == user.getUserID) {
        registerUser = user;
      }
    }
    return registerUser??null;
  }

  bool isTrue(String value)
  {
    if (value == 'true')
      return true;
    else
      return false;
  }
  CurrentUser();
}