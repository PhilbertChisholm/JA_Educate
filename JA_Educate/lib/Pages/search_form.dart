
import 'package:JA_Educate/Content/content.dart';
import 'package:JA_Educate/Pages/add_form.dart';
import 'package:JA_Educate/Services/shared/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Search extends StatefulWidget {
  final String uid;
  Search({this.uid});
  @override
  Tab2 createState() {
    return Tab2();
  }
}

class Tab2 extends State<Search> {
  String search;
  String filter;
  String sort;
  bool _sort = false;
  @override
  Widget build(BuildContext context) {
    final _content = Provider.of<List<Content>>(context, listen: true)??[];
    List<Content> result = [];
    if(search != null)
      {
        for(var content in _content)
          {
            print(search.toLowerCase()+" : "+ content.getTitle+"\n"+content.getTitle.toLowerCase().contains(search, 0).toString());
            if(content.getTitle.toLowerCase().contains(search.toLowerCase(), 0)|| content.getAuthor.toLowerCase().contains(search.toLowerCase(), 0)
                || content.getDescription.toLowerCase().contains(search.toLowerCase(), 0) || content.getContent.toLowerCase().contains(search.toLowerCase(), 0)){
              if(filter != null && filter == content.getContentID) {
                result.add(content);
              }
              else if (filter == null)
                {result.add(content);}
            }
          }
      }
    else
      {result = _content;}
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'search',
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                                          icon: Icon(Icons.search),
                            onPressed: (){
                            setState(() {
                               });
                            },),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          search = value.trim();
                        });
                      }),
                ),


                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
                      child:
                      // Expanded(
                      // child:
                      DropdownButton<String>(
                        icon: Icon(Icons.filter),
                        //controller: titleController,
                        hint: Text('filter'),
                        value: filter,
                        items: [
                          "none",
                          "General info",
                          "Audios",
                          "Books & Articles",
                          "Videos"
                        ]
                            .map((label) =>
                            DropdownMenuItem<String>(
                              // value: _chosenValue,
                                child: Text(label),
                                value: label
                            )).toList(),
                        onChanged: (value) {
                          setState(()
                          //print('choosen '+value);
                          => filter = value
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
                      child:
                      // Expanded(
                      // child:
                      DropdownButton<String>(

                        icon: Icon(Icons.sort),
                        //controller: titleController,
                        hint: Text('sort by date'),
                        value: sort,
                        items: [
                          "Ascending",
                              "Descending",
                        ]
                            .map((label) =>
                            DropdownMenuItem<String>(
                              // value: _chosenValue,
                                child: Text(label),
                                value: label
                            )).toList(),
                        onChanged: (value) {
                          setState(() {
                            sort = value;
                            value == "Ascending" ? _sort = true : false;
                            value == "Descending" ? _sort = false: false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                 Center(
                   child: Container(
                     height: 300,
                     child: ListView.builder(
                          reverse: _sort,
                          scrollDirection: Axis.vertical,
                          itemCount: result == null ? 0 : result.length,
                          itemBuilder: (context, int index){
                            Content obj = result[index];
                            if (result.isEmpty) {
                              return Card(
                                elevation: 1,
                                child: Center(
                                  child: new Container(
                                    width: 300.0,
                                    height: 220,
                                    padding: EdgeInsets.all(20),
                                    child: Text("No content found"),
                                  ),
                                ),
                              );
                            }
                            else {
                              String img = "images/information.png";
                              BoxFit boxfit = null;
                              Widget imgWidget;
                              print("error 0");

                              if(int.parse(obj.typeID) == 1){
                                print("error 1");
                                img = "images/information.png";
                                imgWidget = Image.asset(
                                  img ,
                                  height: 50,
                                  width: 50,
                                  fit: boxfit,
                                );
                              }
                              else if(int.parse(obj.typeID)  == 3)
                              {
                                print("error 3");
                                img = "images/audiofile.png";
                                imgWidget = Image.asset(
                                  img ,
                                  height: 50,
                                  width: 50,
                                  fit: boxfit,
                                );
                              }
                              else{
                                print("error at else");
                                if(obj.getURL.toLowerCase().contains("youtube.com/", 0)){
                                  print(obj.getURL);
                                  img = 'https://img.youtube.com/vi/${obj.getURL.substring(obj.getURL.length -11)}/0.jpg';
                                  print("error at 2");
                                }
                                else{
                                  print("error at 3");
                                  img = obj.getURL;}


                                boxfit = BoxFit.fill;
                                if(obj.getURL == "")
                                {
                                  print("error at 4");
                                  imgWidget = Icon(Icons.warning,size: 30,color: Colors.yellowAccent.withOpacity(0.9),);
                                }
                                else{
                                  print("error at 5");
                                  imgWidget = Image.network(
                                    img ,
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    fit: boxfit,

                                  );
                                }
                                print("error at end");
                              }
                              return Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomLeft: Radius.circular(50)),
                                    ),
                                    elevation: 10,
                                    color: Colors.white,
                                    child: new Container(
                                      margin: EdgeInsets.all(10),
                                      height: 200,
                                      width: 320.0,
                                      child:
                                      Stack(children: <Widget>[

                                        Container(
                                          height: 160,
                                          padding: EdgeInsets.only(bottom: 5),
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
                                            child: imgWidget,)
                                        ),
                                        Container(alignment: Alignment.bottomRight,
                                          child: IconButton(
                                            color: Colors.black,
                                            icon: Icon(Icons.more_vert),
                                            alignment: Alignment.topRight,
                                            onPressed: () {
                                              Functions().moreDialog(context: context,uid: widget.uid, content: obj,);//_moreDialog(context, obj.contentID, obj);
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
                                  index == result.length-1 ? SizedBox(height: 50): SizedBox(height: 5,),
                                ],
                              );
                            }
                          }),
                   ),
                 ),
              ]
          ),
        ),
      ),
    );
  }
}
