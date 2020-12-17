import 'package:JA_Educate/Content/comment.dart';
import 'package:JA_Educate/Content/content.dart';
import 'package:JA_Educate/Content/log.dart';
import 'package:JA_Educate/Content/type.dart';
import 'package:JA_Educate/Entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference commentsCollection = FirebaseFirestore.instance.collection("comments");
  final CollectionReference contentCollection = FirebaseFirestore.instance.collection("content");
  final CollectionReference logCollection = FirebaseFirestore.instance.collection("user_logs");
  final CollectionReference typeCollection = FirebaseFirestore.instance.collection("content_types");
  final CollectionReference ratingCollection = FirebaseFirestore.instance.collection("ratings");

  Future<dynamic> updateRatings(String uid, String rating) async
  {
    Map<String, String> ratings = {
      'rating': rating,
    };
    return ratingCollection.doc(uid).set(ratings);
  }

Future<dynamic> updateUserData(Users user) async
{
  print(user.toString());
  Map<String, String> userData = {
    'firstname': user.getFirstName ?? " ",
    'lastname': user.getLastName ?? " ",
    'username': user.getUsername ?? " ",
    'firstname': user.getFirstName ?? " ",
    'email': user.getEmail ?? " ",
    'password': user.getPassword ?? " ",
    'date_created': user.getDateCreated ?? " ",
    'contact': user.getContact ?? " ",
    'address': user.getAdress ?? " ",
    'biography': user.getBio ?? " ",
    'validation': user.getValidation ?? " ",
    'uid': user.getUserID ?? " ",
    'enable': user.getEnabled ?? " ",
    'expert': user.getIsExpert ?? " ",
    'admin': user.getIsAdmin ?? " "
  };
  return await usersCollection.doc(user.getUserID).set(userData);

}
List<Users> _userList(QuerySnapshot snapshot){
  return snapshot != null ? snapshot.docs.map((doc){
    return Users.user(
      firstName: doc.data()['firstname'].toString()?? '',
      LastName: doc.data()['lastname'].toString()?? '',
      username: doc.data()['username'].toString()?? '',
      email: doc.data()['email'].toString()?? '',
      password: doc.data()['password'].toString()?? '',
      dateCreated: doc.data()['date_created'].toString()?? '',
      contact: doc.data()['contact'].toString()?? '',
      address: doc.data()['address'].toString()?? '',
      bio: doc.data()['biography'].toString()?? '',
      validation: doc.data()['validation'].toString()?? '',
      userID: doc.data()['uid'].toString()?? '',
      isExpert: doc.data()['expert'].toString()?? '',
      isAdmin: doc.data()['admin'].toString()?? '',
      enabled: doc.data()['enable'].toString()?? ''
    );
  }).toList() : null;
}

  List<Content> _contentList(QuerySnapshot snapshot){
    return snapshot!= null ? snapshot.docs.map((doc){
    return  Content(
        contentID: doc.data()['contentID'].toString()??"",
        typeID: doc.data()['typeID'].toString() ??"",
        userID: doc.data()['uid'].toString()??"",
        totalVerifications: doc.data()['totalVerification'].toString() ?? "0",
        description: doc.data()['description'].toString() ??"",
        author: doc.data()['author'].toString() ??"",
        datePublish: doc.data()['published'].toString() ??"",
        dateAdded: doc.data()['dateAdded'].toString() ??"",
        URL: doc.data()['url'].toString() ??"",
        title: doc.data()['title'].toString() ??"",
        isVerified:doc.data()['verified'].toString()??"",
        content: doc.data()['content'].toString() ??"",);
  }).toList() : null;

  }
  Future<dynamic> updateContentData(Content content) async
  {
    Map<String, String> userData = {
      'author': content.getAuthor,
      'uid': content.getUserID.toString(),
      'contentID': content.getContentID.toString(),
      'dateAdded': content.getDateAdded,
      'published': content.getDatePublish,
      'description': content.getDescription,
      'verified': content.getIsVerified.toString(),
      'title': content.getTitle,
      'totalVerification': content.getTotalVerifications.toString(),
      'typeID': content.getTypeID.toString(),
      'url': content.getURL,
      'content': content.getContent
    };
    return await contentCollection.doc(content.getContentID).set(userData);
  }

  Future<dynamic> updateCommentData(Comment obj) async
  {
    Map<String, String> userData = {
      'contentID': obj.getContentID.toString(),
      'category': obj.getCategory,
      'comment': obj.getComment,
      'id': obj.getId.toString(),
      'uid': obj.getuserID.toString(),
    };
    return await commentsCollection.doc().set(userData);
  }

  List<Comment> _commentList(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Comment(
         ID: doc['id'].toString() ?? '',
          userID: doc['uid'].toString() ?? '',
          contentID: doc['contentID'].toString() ?? '',
          category: doc['category'].toString() ?? '',
          comment: doc['comment'].toString() ?? '',);
    }).toList();

  }
  Future<dynamic> updateLogData(Log obj) async
  {
    Map<String, String> userData = {
      'contentID': obj.getContentID.toString(),
      'uid': obj.getUserID.toString(),
      'logID': obj.getLogID.toString(),
      'description': obj.getDescription,
      'date': obj.getDate,
    };
    return await commentsCollection.doc().set(userData);
  }

  List<Log> _logList(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Log(
          doc['logID'].toString() ?? '',
          doc['contentID'].toString() ?? '',
          doc['uid'].toString() ?? '',
          doc['description'].toString() ?? '',
          doc['date'].toString() ?? '');
    }).toList();

  }
  Future<dynamic> updatetypeData(Type obj) async
  {
    Map<String, String> userData = {
      'typeID': obj.getTypeID.toString(),
      'date': obj.getDateCreated,
      'name': obj.getName,
      'description': obj.getDescription,
      'uid': obj.getuserID.toString(),
    };
    return await commentsCollection.doc().set(userData);
  }
  List<Type> _typeList(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Type(
          doc['typeID'].toString() ?? '',
          doc['uid'].toString() ?? '',
          doc['name'].toString() ?? '',
          doc['description'].toString() ?? '',
          doc['date'].toString() ?? '');
    }).toList();

  }

  Stream<List<Users>> get users{
  return usersCollection.snapshots().map(_userList);
  }
  Stream<List<Content>> get contents{
    return contentCollection.snapshots().map(_contentList);
  }
  Stream<List<Comment>> get comments{
    return commentsCollection.snapshots().map(_commentList);
  }
  Stream<List<Type>> get type{
    return typeCollection.snapshots().map(_typeList);
  }
  Stream<List<Log>> get logs{
    return logCollection.snapshots().map(_logList);
  }
  Stream<QuerySnapshot> get con{
    return contentCollection.snapshots();
  }
}