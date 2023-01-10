import 'package:book_club/screens/root/root.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is home"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async{
            CurrenState currenState=Provider.of(context,listen: false);
            String returnString=await currenState.signOut();
            if(returnString=="success"){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot(),), (route) => false);
            }
          },
          child: Text("Sign Out"),
        ),
      ),
    );
  }
}
