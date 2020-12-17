import 'package:JA_Educate/Content/comment.dart';
import 'package:JA_Educate/Content/content.dart';
import 'package:JA_Educate/Entities/user.dart';
import 'package:JA_Educate/Pages/search_form.dart';
import 'package:JA_Educate/Services/shared/feedback.dart';
import 'package:JA_Educate/Services/shared/function.dart';
import 'package:JA_Educate/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:JA_Educate/Services/db.dart';


List<Comment> commentList = [];
String dailyLesson = "on this day";
String uid;
class Home extends StatefulWidget {
 final String uid;
  Home({this.uid});
  @override
  Tab1 createState() {
    return Tab1();
  }

}

class Tab1 extends State<Home> {

  @override
  Widget build(BuildContext context) {

uid = widget.uid;
List<Content> getContentList(int type) {
  final List<Content> content = Provider.of<List<Content>>(context) ?? [];//<List<Content>>(context);
  final List<Comment> comments = Provider.of<List<Comment>>(context)??[];
  commentList = comments;
  List<Content> cons = [];

  for (var doc in content) {
    if(doc.getTypeID == type.toString()) {
      if(doc.getContentID == '2')
        {dailyLesson = doc.getContent;}
      print("init "+cons.toString());
      cons.add(doc);
    }

  }

  return cons;
}

      //print("heres "+ .toString());
      int count_one = 0;

      Widget _listBuilder(int val){
List<Content> cons = getContentList(val);
        List<String> response =["no general content available",
          "no video available",
              "no audio available",
              "no articule or book available"];
        bool _isTypeContent =true;

              if(cons.isEmpty){
                return Center(child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red[200].withOpacity(0.9),
                    child: Text(response[val-1])),);
              }
              else {
                return
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cons.length,
                    itemBuilder: (context, int index) {
                        Content obj = cons[index];
                        if (count_one >= 10) {
                          index = cons.length;
                          return Card(
                            elevation: 1,
                            child: Center(
                              child: new Container(
                                width: 250.0,
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    FloatingActionButton(
                                        child: Icon(Icons.navigate_next),
                                        onPressed: () {
                                          setState(() {
                                            Search();//fix
                                          });
                                        }),
                                    Text("view more"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        else {
                          String img = "images/information.png";
                          BoxFit boxfit = null;
                          Widget imgWidget;

                          if(val == 1){
                            img = "images/information.png";
                            imgWidget = Image.asset(
                              img ,
                              height: 50,
                              width: 50,
                              fit: boxfit,
                            );
                          }
                          else if(val == 3)
                            {
                              img = "images/audiofile.png";
                              imgWidget = Image.asset(
                                img ,
                                height: 50,
                                width: 50,
                                fit: boxfit,
                              );
                            }
                            else{
                              if(cons[index].getURL.toLowerCase().contains("youtube.com/", 0)){
                                img = 'https://img.youtube.com/vi/${cons[index].getURL.substring(cons[index].getURL.length -11)}/0.jpg';
                                print (img);
                              }
                              else{img = cons[index].getURL;}


                              boxfit = BoxFit.fill;
                              if(cons[index].getURL == "")
                                {
                                  imgWidget = Icon(Icons.warning,size: 30,color: Colors.yellowAccent.withOpacity(0.9),);
                                }
                              else{
                                imgWidget = Image.network(
                                  img ,
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                  fit: boxfit,

                                );
                              }
                          }
                          count_one++;
                          return Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                ),
                                elevation: 2,
                                color: Colors.white,
                                  child: new Container(
                                    margin: EdgeInsets.all(10),
                                    height: 232,
                                    width: 300.0,
                                    child:
                                    Stack(children: <Widget>[

                                      Container(
                                        height: 190,
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(19)),
                                          child: imgWidget,)
                                      ),
                                      Container(alignment: Alignment.bottomRight,
                                        child: IconButton(
                                          color: Colors.black,
                                          icon: Icon(Icons.more_vert),
                                          alignment: Alignment.bottomRight,
                                          onPressed: () {
                                            Functions().moreDialog(context: context,uid: widget.uid, content: obj,);
                                          },),),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        child: CircleAvatar(
                                            child: Text(obj.getAuthor == "" ? "A" : obj.getAuthor.substring(0,1), textAlign: TextAlign.center,)),),

                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(obj.getTitle ?? "no description title", textAlign: TextAlign.center,),),
                                    ],),

                                  ),
                              ),

                            ],
                          );
                        }
                      }
                  );
              }
      }

    return  Scaffold(
      backgroundColor: Colors.transparent,
          body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  //child: ConstrainedBox(
                  //constraints: BoxConstraints(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Stack( children: <Widget>[
                        Container(
                          height: 100.0,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black,),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white10.withOpacity(0.5),
                                //background color of box
                                blurRadius: 25.0,
                                // soften the shadow
                                spreadRadius: 5.0,
                                //extend the shadow
                                offset: Offset(
                                  15.0, // Move to right 10  horizontally
                                  15.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child:
                          Padding(
                            padding:EdgeInsets.only(left: 5, ),
                            child:
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerLeft,
                              child:

                              Text(
                                dailyLesson,
                                textAlign: TextAlign.left, style: TextStyle(fontSize:13),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.only(left: 25, top: 6),
                          child:
                          Container(
                            width: 103,
                            color: Colors.white10.withOpacity(1),
                            alignment: Alignment.topLeft,
                            child:

                            Text(
                              "Today's Lesson",
                              textAlign: TextAlign.left, style: TextStyle(fontStyle: FontStyle.italic,fontSize:14),
                            ),
                          ),
                        ),
                      ],
                      ),
                      Text('General Info'),
                      Container(
                        height: 260.0,
                        //width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 10, 5, 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300].withOpacity(0.5),
                              //background color of box
                              blurRadius: 15.0,
                              // soften the shadow
                              spreadRadius: 5.0,
                              //extend the shadow
                              offset: Offset(
                                9.0, // Move to right 10  horizontally
                                9.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            child: _listBuilder(1),
                          ),
                        ),
                      ),
                      Text('\nVideos\n'),
                      Container(
                        height: 260.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300].withOpacity(0.5),
                              //background color of box
                              blurRadius: 15.0,
                              // soften the shadow
                              spreadRadius: 5.0,
                              //extend the shadow
                              offset: Offset(
                                9.0, // Move to right 10  horizontally
                                9.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            child:  _listBuilder(2),
                          ),
                        ),
                      ),
                      Text('\nAudios\n'),
                      Container(
                        height: 260.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300].withOpacity(0.5),
                              //background color of box
                              blurRadius: 10.0,
                              // soften the shadow
                              spreadRadius: 5.0,
                              //extend the shadow
                              offset: Offset(
                                9.0, // Move to right 10  horizontally
                                9.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            child:  _listBuilder(3),
                          ),
                        ),
                      ),
                      Text('\nArticules and Books\n'),
                      Container(
                        height: 260.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300].withOpacity(0.5),
                              //background color of box
                              blurRadius: 15.0,
                              // soften the shadow
                              spreadRadius: 5.0,
                              //extend the shadow
                              offset: Offset(
                                9.0, // Move to right 10  horizontally
                                9.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            child:  _listBuilder(4),
                          ),
                        ),
                      ),
                      SizedBox(height: 50,)
                    ],
                  ),
                ),
              ),
              // ),
            ]),
          ),
    );
  }
}

Widget _moreDialog(BuildContext context, String id, Content content)// pass object to be processed
{
  showDialog<Widget>(
      context: context,
      builder: (BuildContext context){
        return SimpleDialog(

          // make class form data and link the user to the added data
          //link the comment with the data's ID
            title: Text("more", style: TextStyle (fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center, ),
            children:[
              Column(
                  children: <Widget>[
                    Container(
                      //width: 75,
                        child:
                        Column(
                          children:<Widget> [
                            FlatButton(
                              child: Row(children:<Widget>[Icon(Icons.description),Text('Description', style: TextStyle(fontSize: 10),),]),
                              onPressed: (){
                                return SimpleDialog(title: Text(content.getTitle),
                                  children: [
                                    Text("Added on: "+content.getDateAdded),
                                    Text("Published on: "+content.getDatePublish),
                                    Text("Description"+content.getDescription),],);
                              },
                            ),
                            FlatButton(
                              child: Row(children:<Widget>[Icon(Icons.comment), Text('feedbacks', style: TextStyle(fontSize: 10),),]),
                              onPressed: (){
                                Feedbacks().showCommentButtomSheet(context: context, contentID: id, category: "general", uid: uid, comments: commentList);
                              },
                            ),
                            FlatButton(
                              child: Row(children:<Widget>[Icon(Icons.watch_later), Text('View later', style: TextStyle(fontSize: 10),),]),
                              onPressed: (){},
                            ),

                          ],)
                    ),
                  ]
              ),
            ]
        );
      }
  );
}

