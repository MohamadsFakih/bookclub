import 'package:book_club/screens/createGroup/creategroup.dart';
import 'package:book_club/screens/joinGroup/joingroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OurnoGroup extends StatelessWidget {
  const OurnoGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void goToJoin(BuildContext context){
      Navigator.push(context,
      MaterialPageRoute(builder: (context)=>OurJoinGroup()));
    }
    void goToCreate(BuildContext context){
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>OurCreateGroup()));
    }

    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1,),
          Padding(padding: EdgeInsets.all(80),
          child: Image.asset("assets/book.png"),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text("Welcome to Book Club",style: TextStyle(fontSize: 40,color: Colors.grey[600]),
            textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Since you are not in a book club, you can select to either join or create a club",
            style: TextStyle(fontSize: 20,color: Colors.grey[600]),
              textAlign: TextAlign.center,),
          ),
          Spacer(flex: 1,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    onPressed: (){
                      goToCreate(context);
                    },
                    child: Text("Create",),
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(20.0),
                      side: BorderSide(color: Theme.of(context).secondaryHeaderColor,width: 2)),
                ),
                RaisedButton(
                  onPressed: (){
                    goToJoin(context);
                  },
                  child: Text("Join",style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
