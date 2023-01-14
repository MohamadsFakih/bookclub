import 'package:book_club/screens/addBookScreen/addBook.dart';
import 'package:book_club/screens/noGroup/nogroup.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState(){
    super.initState();
    CurrenState currenState=Provider.of<CurrenState>(context,listen: false);
    CurrentGroup currentGroup=Provider.of<CurrentGroup>(context,listen: false);
    currentGroup.updateStateFromDatabase(currenState.getCurrentUser.groupId);

  }

  void goToAddBook(BuildContext context){
    CurrentGroup currentGroup=Provider.of<CurrentGroup>(context,listen: false);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>OurAddBook(groupName: currentGroup.getCurrentGroup.name, onGroupCreation: false)));

  }

  void signOut(BuildContext context)async{
    CurrenState currenState=Provider.of(context,listen: false);
    String returnString=await currenState.signOut();
    if(returnString=="success") {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => OurRoot(),), (
          route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OurContainer(
              child: Consumer<CurrentGroup>(

                builder: (BuildContext context, value, Widget? child) {
                  return Column(
                    children: [
                      Text((value.getCurrentBook.name!= "")? value.getCurrentBook.name: "Loading...",
                        style: TextStyle(fontSize: 20,color: Colors.grey),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Text("Due In:",style: TextStyle(fontSize: 20,color: Colors.grey),),
                            Expanded(child: Text(value.getCurrentGroup.currentBookDue.toDate().toString().split('.')[0]??"Loading",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),))
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: (){},
                        child: Text("Finished Book",style: TextStyle(color: Colors.white),),
                      )
                    ],
                  );
                },

              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: OurContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Next book revealed in",style: TextStyle(fontSize: 20,color: Colors.grey),),
                      Text("22 Hours",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
                    ],
                  ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            child: RaisedButton(
              onPressed: (){
                goToAddBook(context);
                },
              child: Text("Book Club History",
                style: TextStyle(color: Colors.white),),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: RaisedButton(
                onPressed: ()=>signOut(context),
              child: Text("Sign Out"),
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(20.0),
              side: BorderSide(color: Theme.of(context).secondaryHeaderColor,width: 2)),
            ),
          ),

        ],
      )
    );
  }
}
