import 'package:JA_Educate/Entities/anonymous_user.dart';
import 'package:JA_Educate/Entities/user.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AnonymousUser _anonymousUser(User user)
  {
    return user != null ? AnonymousUser(user.uid) : null;
  }
  Users _userFromFirebase(User user)
  {
    return user != null ? Users(user.uid) : null;
  }
  //authentication change user stream
      Stream<AnonymousUser> get user{
    return _auth.authStateChanges().map(_anonymousUser);
      }

      Stream<Users> get registeredUser{
    return _auth.authStateChanges().map(_userFromFirebase);
      }
  //Anonymous signin function
  Future signInAnonymous() async{
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _anonymousUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future registerAccount(String email, String password) async{

    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user.uid;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  // create user doc in database

  Future login(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user.uid;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //Sign out
Future logOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }

}
}