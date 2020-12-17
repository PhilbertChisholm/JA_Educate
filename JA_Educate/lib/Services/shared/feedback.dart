import 'package:JA_Educate/Content/comment.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Feedbacks {
  String contentID;

  Widget showCommentButtomSheet({BuildContext context, String contentID, String category, String uid,  List<Comment> comments}){
    List<Comment> comment = [];
    for (var doc in comments) {
      if (doc.getContentID == contentID) {
        comment.add(doc);
      }
    }
    var commentController = TextEditingController();
    String _comment;
    showModalBottomSheet<void>(context: context, builder: (context){
      return Container(padding: EdgeInsets.all(10),
          height: 410,
          width: 200,
            child: Column(
              children: [
                TextField(
                  maxLines: 1,
                  controller: commentController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'add your comment',
                    suffixIcon: IconButton(icon: Icon(Icons.send),
                      onPressed: () {
                        Comment comment = new Comment(userID: uid,
                          contentID: contentID,
                          category: category,
                          comment: _comment,);
                        DatabaseService().updateCommentData(comment);
                      },),
                  ),
                  onChanged: (String value) {
                    _comment = value;
                    //setstate(()=> );
                  },
                ),
                Container(
                  height: 290,
                  padding: EdgeInsets.only(bottom: 5),
                  child: ListView.builder(
                      itemCount: comment.length,
                      itemBuilder: (context, int index){
                        if(comment == null)
                        {
                          return Text("no comments");
                        }
                        else{
                          return
                              Container(padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[200],style: BorderStyle.solid ),
                                  ),
                                  child: Text(comment[index].getComment),
                          );
                        }
                      }
                  ),
                ),
              ],
            ),
      );
    });
  }

}

