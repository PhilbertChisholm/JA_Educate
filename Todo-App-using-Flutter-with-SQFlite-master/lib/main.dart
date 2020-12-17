import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      color:  Colors.green,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() => new MyPageState();
}

class MyPageState extends State<MyPage> {
  var items = new List<String>();
  var indx = 0;
  var edt = false;
  var txtDList = new List<TextDecoration>();
  var txtDDone = new List<String>();
  var itemIds = new List<int>();
   final myController = TextEditingController();


  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('ToDo List'),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.add), onPressed: () {
            edt = false;
            _showDialog();
          }),
        ],
      ),
      body: makeListView(),
    );
  }

 void _showDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: myController,
                    autofocus: true,
                    decoration: new InputDecoration(
                      labelText: 'Add item:',
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () async {
                  await changeListView();
                  myController.text = "";
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
              new FlatButton(
                onPressed: () {
                  if (edt) {
                    edt = false;
                  }
                  myController.text = "";
                  Navigator.pop(context);},
                child: const Text('cancel'),
              ),
            ],
          );
        }
    );
  }

  void changeListView()  async {
    if (edt) {
      items[indx] = myController.text;
    }
    else {
      if (items == null) {
        items = new List<String>();
        txtDDone = new List<String>();
      }
      try{
        items.add(myController.text);
        txtDDone.add("false");
        txtDList.add(TextDecoration.none);
      } catch(e) {
        print("error in adding: $e");
      }
    }

  Widget makeListView() {
    return new LayoutBuilder(builder: (context, constraint) {
      return new ListView.builder(
        itemCount: items.length == null ? 0 : items.length,
        itemBuilder: (context, index) {
          return new LongPressDraggable(
            key: new ObjectKey(index),
            data: index,
            child: new DragTarget<int>(
              onAccept: (int data) async {
                await _handleAccept(data, index);
              },
              builder: (BuildContext context, List<int> data, List<dynamic> rejects) {
                return new Card(
                    child: new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: new IconButton(icon: const Icon(Icons.strikethrough_s), color: Colors.blue, onPressed: () async {
                            indx = index;
                            await makeStrikeThoroughText();
                          }),
                          trailing: new IconButton(icon: const Icon(Icons.delete), color: Colors.red, onPressed: () async {
                            indx = index;
                            await deleteValue();
                          }),
                          title:
                         Text('${items[index]}', style: TextStyle(decoration: txtDList[index]),),
                          onTap: () {
                            edt = true;
                            indx = index;
                            myController.text = items[index];
                            _showDialog();
                          },
                        ),
                      ],
                    )
                );
              },
              onLeave: (data) {},
              onWillAccept: (int data) {
                return true;
              },
            ),
            onDragStarted: () {
              Scaffold.of(context).showSnackBar(new SnackBar (
                content: new Text("Drag the row onto another row to change places"),
              ));
              },
            onDragCompleted: () {},
            feedback: new SizedBox(
                width: constraint.maxWidth,
                child: new Card (
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: new IconButton(icon: const Icon(Icons.strikethrough_s), color: Colors.blue, onPressed: () async {
                          indx = index;
                        }),
                        trailing: new IconButton(icon: const Icon(Icons.delete), color: Colors.red, onPressed: () async {
                          indx = index;
                        }),
                        title:
                        Text('${items[index]}', style: TextStyle(decoration: txtDList[index]),),
                        onTap: () {
                          edt = true;
                          indx = index;
                          myController.text = items[index];
                        },
                      ),
                    ],
                  ),
                  elevation: 18.0,
                )
            ),
            childWhenDragging: new Container(),
          );
        },
      );
    });
  }

   _handleAccept(int data, int index) async {
    String itemToMove = items[data];
    items.removeAt(data);
    items.insert(index, itemToMove);

    itemToMove = txtDDone[data];
    txtDDone.removeAt(data);
    txtDDone.insert(index, itemToMove);

    txtDList.clear();

    for(int i = 0; i < txtDDone.length; i++) {
      if (txtDDone[i] == "true") {
        txtDList.insert(i, TextDecoration.lineThrough);
      }
      else {
        txtDList.insert(i, TextDecoration.none);
      }
    }
    }
    setState(() {});
  }

 void deleteValue() async {
    items.removeAt(indx);
    txtDDone.removeAt(indx);
    txtDList.removeAt(indx);
    setState(() {});
  }

  void makeStrikeThoroughText() async {
    if (txtDDone[indx] == "true") {
      txtDDone[indx] = "false";
      txtDList[indx] = TextDecoration.none;
    }
    else {
      txtDDone[indx] = "true";
      txtDList[indx] = TextDecoration.lineThrough;
    }
     setState(() {});
    }
}

