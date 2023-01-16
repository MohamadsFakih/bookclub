import 'dart:ffi';

import 'package:book_club/models/book.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OurAddBook extends StatefulWidget {
  final bool onGroupCreation;
  final String groupName;
  const OurAddBook({Key? key,
  required this.groupName,
    required this.onGroupCreation

  }) : super(key: key);



  @override
  State<OurAddBook> createState() => _OurAddBookState();
}

class _OurAddBookState extends State<OurAddBook> {
  TextEditingController bookNameController=TextEditingController();
  TextEditingController authorController=TextEditingController();
  TextEditingController lengthController=TextEditingController();

  DateTime selectedDate=DateTime.now();

  Future<void> selectDate(BuildContext context)async{
    final DateTime? picked=await DatePicker.showDateTimePicker(context,showTitleActions: true);
    if(picked !=null && picked !=selectedDate){
      setState((){
        selectedDate=picked;
      });

    }
  }


  void addBook(BuildContext context,String groupName,OurBook book)async{
    CurrenState currenState=Provider.of<CurrenState>(context,listen: false);
    String returnString;
    if(widget.onGroupCreation){
      returnString= await OurDatabase().createGroup(groupName, currenState.getCurrentUser.uid, book,currenState.getCurrentUser.fullname);
    }else{
      returnString=await OurDatabase().addBook(currenState.getCurrentUser.groupId, book);
    }
    if(returnString=="success"){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot(),), (route) => false);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [BackButton()],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OurContainer(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: bookNameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.book),
                            hintText: "Book Name"
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: authorController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.group),
                            hintText: "Author"
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: lengthController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.numbers),
                            hintText: "Length",
                        ),
                      ),
                      SizedBox(height: 20,),
                      //datepicker
                      Text(DateFormat.yMMMd("en_US").format(selectedDate) ),
                      Text(selectedDate.hour.toString()+":"+selectedDate.minute.toString()),
                      FlatButton(
                          onPressed: (){
                            selectDate(context);
                          },
                          child: Text("Change Date")
                      ),

                      RaisedButton(
                        onPressed: (){
                          OurBook book=OurBook(id: "", name: bookNameController.text.trim(),
                              length: lengthController.text.toString().trim(), dateCompleted: Timestamp.fromDate(selectedDate),
                              author: authorController.text.trim(),image: "");


                            addBook(context, widget.groupName, book);


                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Text("Add Book",style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,fontSize: 20.0),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
