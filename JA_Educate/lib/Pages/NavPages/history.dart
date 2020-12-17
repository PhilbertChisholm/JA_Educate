import 'package:JA_Educate/Content/Filing/persistentData.dart';
import 'package:JA_Educate/Content/log.dart';
import 'package:JA_Educate/Services/db.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class History extends StatefulWidget{
  final String uid;
  final bool isExpert;
  final bool isAdmin;
  PersistentData persistenceData;
  History({this.uid, this.isAdmin, this.isExpert, this.persistenceData});
  @override
  form createState() {
    return form();
  }
}
class form extends State<History>{
  @override
  List<String> filterItem =[];

  String  search;
  String chosenValue;
  String sortValue;
  bool _sort = false;
  int barColor =0xFF00cc33;
  int iconOne = 0xFF18D191;
  int iconTwo = 0xFFFFFFFF;

  Widget build(BuildContext context) {

    if(widget.persistenceData != null)
    {
    barColor = int.parse(widget.persistenceData.getBarColor);
    iconOne = int.parse(widget.persistenceData.getIconColorOne);
    iconTwo = int.parse(widget.persistenceData.getIconColorTwo);

    }
    bool isPermitted = widget.isExpert;
    bool isPrivelleged = widget.isAdmin;
    if (isPrivelleged)
    {filterItem = ["All","Searches", "Viewed", "Verified", "Added", "CRUD"];}
    else if (isPermitted)
    {filterItem = ["All","Searches", "Viewed", "Verified", "Added"];}
    else
    {filterItem = ["All","Searches", "Viewed"];}
    return StreamBuilder<List<Log>>(
      stream: DatabaseService().logs,
      builder: (context, snapshot) {
        List<Log> logList = [];
        if(snapshot.hasData)
       for(var data in snapshot.data)
          {
            if(data.getUserID == widget.uid){
              logList.add(data);
            }
          }
        return Scaffold(
          appBar: AppBar(
            title: Text("History", style: TextStyle(fontSize: 16),),
            backgroundColor: Color(barColor),
            iconTheme: IconThemeData(color: Color(iconTwo),),

          ),
          body: Container(
            height: 400,
            padding: EdgeInsets.all(10),
            child:
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children:<Widget> [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged: (val){
                        search = val;
                      },

                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.search,),
                            onPressed: (){
                              // search in database
                              //search
                            },
                        ),
                      labelText: 'Search',
                      hintText: 'e.g date, title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                    ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children:<Widget> [
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child:
                        DropdownButton<String>(
                          hint: Text('Filter'),
                          icon: Icon(Icons.filter),
                          value: chosenValue,
                          items: <String>[
                            for(String item in filterItem)
                            item
                          ]
                              .map<DropdownMenuItem<String>>((
                              String value) {
                            return DropdownMenuItem<String>(
                              // value: _chosenValue,
                                child: Text(value));
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              chosenValue = value;
                              //show chosen
                            });
                          },
                        ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerRight,
                          child:
                        DropdownButton<String>(
                          hint: Text('Sort by Date'),
                          icon: Icon(Icons.sort),
                          value: sortValue,
                          items: <String>[
                            "Decending", "Ascending"
                          ]
                              .map<DropdownMenuItem<String>>((
                              String value) {
                            return DropdownMenuItem<String>(
                              // value: _chosenValue,
                                child: Text(value));
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              sortValue = value;
                              value == "Ascending" ? _sort = true : false;
                              value == "Descending" ? _sort = false: false;
                              //show chosen
                            });
                          },
                        ),
                        )
                      ],
                    ),
                  ),
              Container(
                height: 250,
                child: ListView.builder(
                    reverse: _sort ,
                    scrollDirection: Axis.vertical,
                    itemCount: logList.length ?? 0,
                    itemBuilder: (context, int index) {
                    Log obj = logList[index];
                    if(snapshot.hasData)
                    return ListTile(leading: Text("Date: "+ obj.getDate),
                    subtitle: Text(obj.getDescription),
                    );
                    else
                      return Container(
                          child: Card(
                            elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                              ),
                              child: Container(
                                height: 40,
                                width:75,
                                decoration: BoxDecoration(border: Border.all(color: Color(0xFF18D191), style: BorderStyle.solid),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                ),
                                child: Center(
                                  child: Text('no data found',
                                      textAlign: TextAlign.center, style: GoogleFonts.alegreya(fontSize: 24, )),
                                ),)
                          ),
                      );
    }
                ),
              ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


