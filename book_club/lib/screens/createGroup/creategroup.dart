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

  void createGroup(BuildContext context,String groupName)async{
    CurrenState currenState=Provider.of<CurrenState>(context,listen: false);
    String returnString = await OurDatabase().createGroup(groupName, currenState.getCurrentUser.uid);
    if(returnString=="success"){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot(),), (route) => false);
    }

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
                              createGroup(context, groupNameController.text.trim());
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
