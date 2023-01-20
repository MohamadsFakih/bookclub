import 'package:book_club/screens/addBookScreen/addBook.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurCreateGroup extends StatefulWidget {
  const OurCreateGroup({Key? key}) : super(key: key);

  @override
  State<OurCreateGroup> createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {

  void goToAddBook(BuildContext context,String groupName)async{

      Navigator.push(context, MaterialPageRoute(builder: (context)=> OurAddBook(groupName: groupName, onGroupCreation: true,
      name: "",bookLink: "",length: "",author: "",image: "",)));


  }

  TextEditingController groupNameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(20.0),
            child: Row(
              children: [BackButton()],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(20.0),
                  child: OurContainer(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: groupNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.group),
                            hintText: "Group Name"
                          ),
                        ),
                          SizedBox(height: 20,),
                        RaisedButton(
                            onPressed: (){
                              goToAddBook(context, groupNameController.text.trim());
                            },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text("Create",style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,fontSize: 20.0),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
