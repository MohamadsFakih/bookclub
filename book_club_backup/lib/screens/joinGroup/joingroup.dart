import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import '../../states/currentuser.dart';
import '../root/root.dart';

class OurJoinGroup extends StatefulWidget {
  const OurJoinGroup({Key? key}) : super(key: key);

  @override
  State<OurJoinGroup> createState() => _OurJoinGroupState();
}

class _OurJoinGroupState extends State<OurJoinGroup> {


  void joinGroup(BuildContext context,String groupId)async{
    CurrenState currenState=Provider.of<CurrenState>(context,listen: false);
    String returnString = await OurDatabase().joinGroup(groupId, currenState.getCurrentUser.uid,currenState.getCurrentUser.fullname);
    if(returnString=="success"){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot(),), (route) => false);
    }

  }

  TextEditingController groupIdController=TextEditingController();
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
                          controller: groupIdController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.group),
                              hintText: "Group Id"
                          ),
                        ),
                        SizedBox(height: 20,),
                        RaisedButton(
                          onPressed: (){
                            joinGroup(context, groupIdController.text.trim());
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text("Join",style: TextStyle(color: Colors.white,
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
