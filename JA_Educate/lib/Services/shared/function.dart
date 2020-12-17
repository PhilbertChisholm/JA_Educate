import 'dart:convert';

import 'package:JA_Educate/Content/Filing/persistentData.dart';
import 'package:JA_Educate/Content/comment.dart';
import 'package:JA_Educate/Content/content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'feedback.dart';

class Functions{
  final String uid;
  List<Comment> commentList=[];
  SharedPreferences _sharedPreferences;
  List<PersistentData> persis = [];
  PersistentData persistence;
  Functions({this.uid});

  //---------------------------shared Preferences---------------------------------
  Future<PersistentData> loadSharePreferencesData() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    return loadData();
  }

  PersistentData loadData(){
    List<String> data = _sharedPreferences.getStringList('list');
    if(data!=null){
      persis = data.map((item)
      => PersistentData.fromMap(json.decode(item)
      )).toList();
      return persis[0];
    }
    return null;
  }
  void saveData(PersistentData persisdata)async{
    loadSharePreferencesData();
    if(persisdata == null)
      {
        print("persis clear ");
        await _sharedPreferences.clear();
      }
    else {
      persis = [];
      persis.add(persisdata);
      print("persis add "+ persisdata.getUid);
      List<String> data = await persis.map((item) => json.encode(item.toMap()))
          .toList();
      _sharedPreferences.setStringList('list', data);
    }

  }
//--------------------------content dialog----------------------------------------
  Widget moreDialog({BuildContext context, String uid, Content content})// pass object to be processed
  {

    final List<Comment> comments = Provider.of<List<Comment>>(context, listen: false)??[];
    final Key key = GlobalKey();
    commentList = comments;
    showDialog<Widget>(
        context: context,
        builder: (context){
          return StatefulBuilder( builder: (BuildContext context, setState) => SimpleDialog(
            key: key,
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
                                    Navigator.of(context).pop();
                                    description (content, context);
                                  },
                                ),
                                FlatButton(
                                  child: Row(children:<Widget>[Icon(Icons.comment), Text('feedbacks', style: TextStyle(fontSize: 10),),]),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    Feedbacks().showCommentButtomSheet(context: context, contentID: content.getContentID, category:int.parse(content.getTotalVerifications)>5 ?"verification":"general", uid: uid, comments: commentList);
                                    },
                                ),
                                FlatButton(
                                  child: Row(children:<Widget>[Icon(Icons.watch_later), Text('View later', style: TextStyle(fontSize: 10),),]),
                                  onPressed: (){Navigator.of(context).pop();},
                                ),
                                FlatButton(
                                  child: Row(children:<Widget>[Icon(Icons.play_circle_filled), Text('View', style: TextStyle(fontSize: 10),),]),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    viewFilter(content, context);
                                  },
                                ),

                              ],)
                        ),
                      ]
                  ),
                ]
            ),
          );
        }
    );
  }
//----------------------youtube player---------------------------------------------
  void video(String url, BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: url,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ));
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          //title: Text(url),
            children: [
              Column(
                children: <Widget>[
                  /*IconButton(
                             icon: Icon(Icons.cancel),
                            color: Colors.red,
                            highlightColor: Colors.black,
                            alignment: Alignment.topRight,
                            //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            onPressed: () {
                                Navigator.pop(context);
                            },
                        ),*/
                  new FittedBox(
                    alignment: Alignment.topCenter,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ]);
      },
    );
  }

  //--------------------------View Content--------------------------------------------------
void viewFilter (Content content, BuildContext context){
  if(content.getTypeID == '2')
      {
        if(content.getURL != null)
          {
            if(content.getURL.toLowerCase().contains("youtube.com/", 0))
              {
                video(content.getURL.substring(content.getURL.length -11), context);
              }
            else
              {
                _launch(content.getURL);
              }
          }
        else{
          _launch(content.getContent);
        }
      }
    else if(content.getTypeID == 3)
      {
        if(content.getURL != "")
          {
            _launch(content.getURL);
          }
        else{
          //play audio
        }
      }
    else {
      if(content.getURL != "")
      {
        print("not null");
        _launch(content.getURL);
      }
      else{
        viewContent(content, context);
      }
    }
}

//---------------------------------video player---------------------------

//-----------------------audio player--------------------------------------------


//--------------------------open browser-----------------------------------------
Future<void> _launch(String url)async{
    if (await canLaunch(url)){
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
    else{
      throw "Could not launch ${url}";
    }
}
//----------------------------show error dialog----------------------------------
Widget error (String message, BuildContext context){
  showDialog<Widget>(
      context: context,
      builder: (context){
        return StatefulBuilder( builder: (BuildContext context, setState) => AlertDialog(

          // make class form data and link the user to the added data
          //link the comment with the data's ID
            title: Text("Sorry", style: TextStyle (fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center, ),
          content: Text(message, style: TextStyle(color: Colors.red),),
          actions: [
            IconButton( icon: Icon(Icons.close),
            alignment: Alignment.topLeft,
            onPressed: (){
              Navigator.of(context).pop();
            },),
          ],

        ),
        );
      }
  );
}

//------------------------------Content Viewer Dialog----------------------------
  Widget viewContent (Content content, BuildContext context){
    showDialog<Widget>(
        context: context,
        builder: (context){
          return StatefulBuilder( builder: (BuildContext context, setState) => SimpleDialog(

            // make class form data and link the user to the added data
            //link the comment with the data's ID
            title: Text(content.getTitle, style: TextStyle (fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center, ),

            children: [
              Column(
                children: [
                  Text("Publish on: "+ content.getDatePublish ),
                  Text("Author(s): "+ content.getAuthor != null ? content.getAuthor: "Author: anonymous"),
                  SizedBox(height: 10,),
                  Text(content.getContent),
                ],
              ),
            ],

          ),
          );
        }
    );
  }
  //-----------------------------Description----------------------------------------

  Widget description (Content content, BuildContext context){
    showDialog<Widget>(
        context: context,
        builder: (context){
          return StatefulBuilder( builder: (BuildContext context, setState) => SimpleDialog(

            // make class form data and link the user to the added data
            //link the comment with the data's ID
            title: Text(content.getTitle, style: TextStyle (fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center, ),

            children: [
              Column(
                children: [
                  Text("Publish on: "+ content.getDatePublish, textAlign: TextAlign.left, ),
                  SizedBox(height: 10,),
                  Text("Author(s): "+ content.getAuthor == null ? content.getAuthor: "Author: anonymous", textAlign: TextAlign.left),
                  SizedBox(height: 20,),
                  Text(content.getDescription != null ? content.getDescription: "no description", textAlign: TextAlign.left),
                ],
              ),
            ],

          ),
          );
        }
    );
  }

}
