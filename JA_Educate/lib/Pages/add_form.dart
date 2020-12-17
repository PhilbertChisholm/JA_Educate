import 'dart:io';

import 'package:JA_Educate/Content/comment.dart';
import 'package:JA_Educate/Content/content.dart';
import 'package:JA_Educate/Entities/anonymous_user.dart';
import 'package:JA_Educate/Entities/user.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:JA_Educate/Services/shared/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:provider/provider.dart';

bool isPermitted = false;
bool hasVerifications = true;
bool isCreator = false;
Content _editedcontent;
String uid;
class App extends StatefulWidget {
  final String uid;
  final bool isAdmin;
  final bool isExpert;
  String get getUid => this.uid;
  bool get getIsAdmin => this.isAdmin;
  bool get getIsExpert => this.isExpert;
  App({this.uid, this.isAdmin, this.isExpert});
  @override
  AddFormState createState() {
    return AddFormState();
  }
}
class ListItem {
  //convert to object class
  String itemText;
  String itemNumber;
  String itemDescription;
  String itemContent;
  bool verifyCheck;
  ListItem(this.itemText, this.itemNumber, this.itemDescription,this.itemContent, this.verifyCheck);
}

class AddFormState extends State<App> {
  List<ListItem> WidgetList = [];
  List<Content> unverifiedcontent = [];
  bool checkOne = false;
  bool showverifications = false;

  @override
  Widget build(BuildContext context) {
    uid = widget.uid;
    isPermitted = widget.getIsExpert ?? false;
    //check user function
    //final anonUser = Provider.of<AnonymousUser>(context);
    //var registerUser = Provider.of<Users>(context);
   // final  users = Provider.of<List<Users>>(context);
    final List<Content> content = Provider.of<List<Content>>(context) ?? []; //<List<Content>>(context);
    List<Comment> commentList =[];
    final List<Comment> comments = Provider.of<List<Comment>>(context)??[];
    commentList = comments;

     // isPermitted = App().isExpert;
      //uid = App().uid;

// checks if there is content which need verification
void init() {
  int count = 0;
  unverifiedcontent = [];
  for (var doc in content) {
    if (doc.isVerified.toLowerCase() == "false") {
      for (var doc2 in content) {
        if (doc == doc2)
          {
          count++;
          print(count);
          }
      }
      if(count<2)
        unverifiedcontent.add(doc);
    }
  }
}
   init();
      hasVerifications = unverifiedcontent.isEmpty ? false: true;
      Widget form(BuildContext context, bool edit) {
        final _addFormKey = GlobalKey<FormState>();
        int _id = content.length+1 ?? 0;
        var dayController = TextEditingController();
        var monthController = TextEditingController();
        var yearController = TextEditingController();
        var authorController = TextEditingController();
        var urlController = TextEditingController();
        var descriptionController = TextEditingController();
        var titleController = TextEditingController();
        var contentController = TextEditingController();

        void setForm() {
          if (!edit) {
            _editedcontent = null;
          }
        }

        setForm();

        String _contentCategory;
        String _contentType;
        String _day;
        String _month;
        String _year;
        String _author;
        String _url;
        String _description;
        String _title;
        String _content;
        int i = 0;

        void clear(){
          dayController.clear();
          monthController.clear();
          yearController.clear();
          authorController.clear();
          urlController.clear();
          descriptionController.clear();
          titleController.clear();
          contentController.clear();
          _contentType = null;
          _contentCategory = null;
          _content = null;
          _url =null;
          i =0;
        }
        List<String> upload = ["no file uploaded", "file upload"];


        bool isUploaded = false;
        showDialog<Widget>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SimpleDialog(
                    //title: Text(url),
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          child:
                          Form(
                            key: _addFormKey,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child:
                              //Expanded(
                              //child:
                              Column(
                                children: <Widget>[
                                  Text('Add New Content',
                                    textAlign: TextAlign.center,),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                    child: TextFormField(
                                      controller: authorController,
                                      //initialValue: _editedcontent.getAuthor ?? " ",
                                      keyboardType: TextInputType.text,
                                      onChanged: (String value) {
                                        _author = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Author(s)',
                                        hintText: 'Author(s) name',
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            authorController.clear();
                                          },),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10)
                                        ),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Please enter an Author's name!";
                                        }
                                        return null;
                                      },

                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                    child: TextFormField(
                                      controller: titleController,
                                      //initialValue: _editedcontent.getTitle ?? null,
                                      keyboardType: TextInputType.text,
                                      onChanged: (String value) {
                                        _title = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Title',
                                        hintText: 'Enter Content Title',
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            titleController.clear();
                                          },),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10)
                                        ),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a title for your content!';
                                        }
                                        return null;
                                      },

                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                    //child:
                                    //Expanded(
                                    //width: 100,
                                    //padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                    child:
                                    new DropdownButtonFormField<String>(
                                      //controller: titleController,
                                      hint: Text('Choose Category'),
                                      value: _contentCategory,
                                      items: [
                                        "Proverd",
                                        "History",
                                        "Current Affairs",
                                        "National Heros",
                                        "Clothes",
                                        "Food",
                                        "Dance",
                                        "Music",
                                        "Sports",
                                        "Language",
                                        "Folk Customs",
                                        "Observered Dates"
                                      ]
                                          .map((label) =>
                                      new DropdownMenuItem<String>(
                                        // value: _chosenValue,
                                          child: Text(label),
                                          value: label
                                      )).toList(),
                                      onChanged: (item) {
                                        print('choosen ' + item);
                                        setState(()
                                        //print('choosen '+value);
                                        => _contentCategory = item
                                        );
                                      },
                                      validator: (String value) {
                                        if (value == null) {
                                          return "Please select your content's category!";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  //),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                    child:
                                    // Expanded(
                                    // child:
                                    DropdownButtonFormField<String>(
                                      //controller: titleController,
                                      hint: Text('Choose media type'),
                                      value: _contentType,
                                      items: [
                                        "Text",
                                        "Short Fact",
                                        "Audio",
                                        "Book",
                                        "Article",
                                        "Video"
                                      ]
                                          .map((label) =>
                                          DropdownMenuItem<String>(
                                            // value: _chosenValue,
                                              child: Text(label),
                                              value: label
                                          )).toList(),
                                      onChanged: (value) {
                                        print('choosen ' + value);
                                        setState(()
                                        //print('choosen '+value);
                                        => _contentType = value
                                        );
                                      },
                                      validator: (String value) {
                                        if (value == null) {
                                          return "Please select your content's media type!";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                                    child:
                                    Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.only(
                                              bottom: 15),
                                          child: Text("Date published"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20.0),
                                          child: Row(
                                              children: [

                                                Text("dd:",
                                                    style: TextStyle(
                                                        fontSize: 11)),
                                                Expanded(
                                                  child:
                                                  TextFormField(
                                                    controller: dayController,
                                                    //initialValue: _editedcontent
                                                      //  .getDatePublish.substring(
                                                        //0, 2) ?? null,
                                                    style: TextStyle(
                                                        fontSize: 14),
                                                    keyboardType: TextInputType
                                                        .number,
                                                    decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                          fontSize: 12),
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      labelText: 'Day',
                                                      hintText: '01',
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(10)
                                                      ),
                                                    ),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return 'Please enter valid date';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (String value) {
                                                      _day = value;
                                                    },
                                                  ),
                                                ),

                                                Text("mm:",
                                                    style: TextStyle(
                                                        fontSize: 11)),
                                                Expanded(
                                                  child:
                                                  TextFormField(
                                                    controller: monthController,
                                                    //initialValue: _editedcontent
                                                       // .getDatePublish.substring(
                                                        //3, 6) ?? null,
                                                    style: TextStyle(
                                                        fontSize: 14),
                                                    keyboardType: TextInputType
                                                        .number,
                                                    decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                          fontSize: 12),
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      labelText: 'Month',
                                                      hintText: '01',
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(10)
                                                      ),
                                                    ),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return 'Please enter valid date';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (String value) {
                                                      _month = value;
                                                    },
                                                  ),
                                                ),


                                                Text("YYYY:",
                                                    style: TextStyle(
                                                        fontSize: 11)),
                                                Expanded(
                                                  child:
                                                  TextFormField(
                                                    controller: yearController,
                                                    //initialValue: _editedcontent
                                                      //  .getDatePublish.substring(
                                                      //7,) ?? null,
                                                    style: TextStyle(
                                                        fontSize: 14),
                                                    keyboardType: TextInputType
                                                        .number,
                                                    decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                          fontSize: 12),
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      labelText: 'Year',
                                                      hintText: '2020',
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(10)
                                                      ),
                                                    ),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return 'Please enter valid date';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (String value) {
                                                      _year = value;
                                                    },
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child:
                                    Row(
                                        children: [
                                          //width:100,

                                          Checkbox(
                                            value: checkOne,
                                            onChanged: (bool value) {
                                              setState(() {
                                                checkOne = value;
                                              });
                                            },
                                          ),
                                          Expanded(child:
                                          Container(
                                            child:
                                            Text(
                                                'Do You want to upload your content'),
                                          ),),
                                        ]
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Row(
                                      children: <Widget>[


                                        Expanded
                                          (
                                          child:
                                          RaisedButton(

                                            color: !checkOne
                                                ? Colors.grey
                                                : Colors
                                                .blueAccent,

                                            onPressed: !checkOne ? null : () {

                                              print("picking file");
                                             final file =  FilePicker.getFilePath();
                                              //final file = await FlutterDocumentPicker.openDocument().asStream();
                                              _content = file.toString();
                                              print('content '+_content);
                                             setState((){
                                               if(_content != null)
                                               i=1;
                                             });
                                            },

                                            child: Text('choose file'),

                                          ),
                                        ),
                                        Padding
                                          (
                                          padding: EdgeInsets.only(left: 5),
                                          child:
                                          Text(upload[i]),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox
                                    (
                                    child:
                                    Text("--OR--"),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: TextFormField(
                                      controller: contentController,
                                      //initialValue: _editedcontent.getContent ??
                                        //  null,
                                      enabled: !checkOne,
                                      minLines: 1,
                                      maxLines: 100,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Editor',
                                        hintText: 'Enter Content',
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            contentController.clear();
                                          },),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                      onChanged: (String value) {
                                        _content = value;
                                      },

                                      validator: (String value) {
                                        if (value.isEmpty && checkOne &&
                                            !isUploaded) {
                                          return 'Please enter content!';
                                        }
                                        return null;
                                      },

                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                    child: TextFormField(
                                      controller: urlController,
                                      //initialValue: _editedcontent.getURL ?? null,
                                      enabled: !checkOne,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'URL',
                                        hintText: 'Enter content URL address',
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            urlController.clear();
                                          },),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                      onChanged: (String value) {
                                        _url = value;
                                      },

                                      validator: (String value) {
                                        if (value.isEmpty && !checkOne && _content == null) {
                                          return 'Please add content URL!';
                                        }
                                        return null;
                                      },

                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: TextFormField(
                                      enabled: !checkOne,
                                      minLines: 1,
                                      maxLines: 50,
                                      controller: descriptionController,
                                      //initialValue: _editedcontent
                                        //  .getDescription ?? null,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Description',
                                        hintText: 'Enter description',
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            descriptionController.clear();
                                          },),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                      onChanged: (String value) {
                                        _description = value;
                                      },

                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a description of this content!';
                                        }
                                        return null;
                                      },

                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child:
                                          Padding
                                            (
                                            padding: EdgeInsets.only(
                                                left: 1, bottom: 2),
                                            child:
                                            RaisedButton(

                                              onPressed: () {
                                                print(" content here");
                                                if (_addFormKey.currentState
                                                    .validate()) {
                                                  Content _newContent = new Content(
                                                      author: _author,
                                                      contentID: _editedcontent == null ?_id.toString(): _editedcontent.getContentID,
                                                      dateAdded: "${DateTime
                                                          .now()
                                                          .day}/ ${DateTime
                                                          .now()
                                                          .month}/ ${DateTime
                                                          .now()
                                                          .year}",
                                                      datePublish: _day + "/" +
                                                          _month + "/" + _year,
                                                      description: _description,
                                                      isVerified: "false",
                                                      title: _title,
                                                      totalVerifications: "0",
                                                      typeID: _contentType,
                                                      URL: _url ?? "",
                                                      userID: uid,
                                                      content: _content ??
                                                          "" // pass user id to this widget
                                                  );

                                                    if ( _editedcontent !=
                                                        null){
                                                      print(" content edited");
                                                      DatabaseService()
                                                        .updateContentData(
                                                        _editedcontent);
                                                      _editedcontent = null;
                                                    }
                                                    else{
                                                      print(" content new");
                                                     DatabaseService()
                                                        .updateContentData(
                                                    _newContent);}

                                                  setState(() {
                                                    clear();
                                                  });
                                                }
                                              },
                                              color: Colors.green,
                                              child: Text('Submit'),

                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child:
                                          Padding
                                            (
                                            padding: EdgeInsets.only(
                                                left: 4, bottom: 2),
                                            child:
                                            RaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                  dayController.clear();
                                                  monthController.clear();
                                                  yearController.clear();
                                                  authorController.clear();
                                                  urlController.clear();
                                                  descriptionController.clear();
                                                  titleController.clear();
                                                  contentController.clear();
                                                  _contentType = null;
                                                  _contentCategory = null;
                                                });
                                              },
                                              color: Colors.yellowAccent,
                                              child: Text('Reset'),

                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child:
                                          Padding
                                            (
                                            padding: EdgeInsets.only(
                                                left: 4, bottom: 2),
                                            child:
                                            RaisedButton(

                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              color: Colors.red,
                                              child: Text('Cancel'),

                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ),
                        ),
                      ),

                      //),

                    ],
                  );
                },
              );
            }
        );
      }

      Widget verificationList(List<Content> unverifiedcontent) {
        for(final contentWidget in unverifiedcontent){
          print("print"+contentWidget.getAuthor+" : "+ contentWidget.getContent);
          print("print lenght: ${unverifiedcontent.length}");
        }
        if(unverifiedcontent.isEmpty)
          return Container(
              padding: EdgeInsets.all(10),
              color: Colors.red[200].withOpacity(0.9),
              child: Text("No content to be verified")
          );
        else
        return Expanded(child:
        Container(
          height: 300,
          child: ReorderableListView(
            children: <Widget>[
              for(final contentWidget in unverifiedcontent)
                GestureDetector(
                  key: Key(contentWidget.getContentID),
                  child: Dismissible(
                    key: Key(contentWidget.getContentID),
                    child: CheckboxListTile(
                      value: contentWidget.isVerified.toLowerCase() == 'true'
                          ? true
                          : false,
                      title: Text(contentWidget.getTitle),
                      subtitle: Text(contentWidget.getDescription),
                      onChanged: (checked) {
                        setState(() {
                          if (!checked) {
                            //Update database count -- was unchecked
                            contentWidget.totalVerifications = (int.parse(
                                contentWidget.totalVerifications)-1).toString();
                            if (int.parse(contentWidget.totalVerifications) < 5)
                              contentWidget.isVerified = false.toString();
                          }
                          else {
                            contentWidget.totalVerifications = (int.parse(
                                contentWidget.totalVerifications) + 1).toString();
                            if (int.parse(contentWidget.totalVerifications) >= 5)
                              contentWidget.isVerified = true.toString();
                          }
                          DatabaseService().updateContentData(contentWidget);
                        });
                      },
                    ),
                    background: Container(
                      child: Icon(Icons.delete_sweep),
                      alignment: Alignment.centerRight,
                      color: Colors.yellowAccent,
                    ),
                    confirmDismiss: (dismissDirection) async {
                      return await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text("Remove Content"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ), //OK Button
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false);
                                    },
                                  ), //Cancel
                                ]
                            );
                          }
                      );
                    },
                    direction: DismissDirection.endToStart,
                    movementDuration:
                    const Duration(milliseconds: 200),
                    onDismissed: (dismissDirection) {
                      WidgetList.remove(widget);
                      Fluttertoast.showToast(msg: "Content Removed!");
                    },
                  ),
                  onDoubleTap: () async {
                    // need to pass the data to the form
                    uid = widget.uid;
                    isCreator = contentWidget.userID == uid ? true: false;

                    if (isCreator) {
                      _editedcontent = contentWidget;
                      form(context, true);
                    }
                  },
                  onLongPress: () async {// pass comment buttom sheet here
                    Feedbacks().showCommentButtomSheet(context: context, contentID: contentWidget.contentID, category: "verification", uid: widget.uid, comments: commentList);
                  },
                )
            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                var replaceWiget = WidgetList.removeAt(oldIndex);
                WidgetList.insert(newIndex, replaceWiget);
              });
            },
          ),
        ),
        );
      }


  if (isPermitted) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Padding(padding: EdgeInsets.only(top: 15, bottom: 5), child:
                  Text("Expert Options", style:
                  TextStyle(
                      decoration: TextDecoration.overline, fontSize: 14),),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:
                        FlatButton(
                          child:
                          Row(children: <Widget>[
                            Text("Verify info", style: TextStyle(
                                decoration: TextDecoration.underline),),
                            Align(alignment: Alignment.bottomRight,
                              child: Icon(
                                 showverifications? Icons.arrow_drop_down:Icons.arrow_drop_up, color: Colors.black,
                                  size: 20),
                            ),
                            Align(alignment: Alignment.topRight,
                              child: Icon(Icons.info, color: hasVerifications
                                  ? Colors.red
                                  : Colors.green, size: 20,),
                            ),

                          ],),
                          color: Colors.white,
                          onPressed: () =>
                              setState(() =>
                              showverifications = !showverifications),

                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          child:
                          Text("Add content", style: TextStyle(
                              decoration: TextDecoration.underline),),
                          color: Colors.blue,
                          onPressed: () {
                            form(context, false);
                          },
                        ),
                      ),
                    ],
                  ),
                  showverifications
                      ? verificationList(unverifiedcontent)
                      : Text(""),
                ]

            )
        );
      }
  else
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(

          child:
          Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 5, bottom: 20), child:
                Text("Expert Options", style:
                TextStyle(
                    decoration: TextDecoration.overline, fontSize: 14),),),
                Align(
                  alignment: Alignment.center,
                  child: Text("You are not Permitted",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.6))),
                ),
              ]),),
      );
    }
  }

