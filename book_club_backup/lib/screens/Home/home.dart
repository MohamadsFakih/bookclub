import 'dart:async';
import 'dart:io';

import 'package:book_club/screens/addBookScreen/addBook.dart';
import 'package:book_club/screens/bookstest.dart';
import 'package:book_club/screens/noGroup/nogroup.dart';

import 'package:book_club/screens/review/review.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/screens/splashScreen/splash.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:book_club/utils/timeleft.dart';
import 'package:book_club/widgets/HomeBooks.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../widgets/SearchItem.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> timeUntil=List.filled(2, "");// [0] The time the book is due, [1] The time the next book is revealed
  late Timer timer;

  void startTimer(CurrentGroup currentGroup){

    timer=Timer.periodic(Duration(seconds: 1), (timer) {
      setState((){
        timeUntil = OurTimeLeft().timeleft(currentGroup.getCurrentGroup.currentBookDue.toDate());
      });
    });
  }


  @override
  void initState(){
    super.initState();
    CurrenState currenState=Provider.of<CurrenState>(context,listen: false);
    CurrentGroup currentGroup=Provider.of<CurrentGroup>(context,listen: false);
    currentGroup.updateStateFromDatabase(currenState.getCurrentUser.groupId,currenState.getCurrentUser.uid);
    startTimer(currentGroup);

  }
  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  void goToAddBook(BuildContext context){

    CurrentGroup currentGroup=Provider.of<CurrentGroup>(context,listen: false);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>BookTest(gid: currentGroup.getCurrentGroup.id,)));

  }
  void goToReview(BuildContext context){
    CurrentGroup currentGroup=Provider.of<CurrentGroup>(context,listen: false);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>OurReview(currentGroup: currentGroup,)));

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

  void leaveGroup(BuildContext context,String gid)async{
    CurrenState currenState=Provider.of(context,listen: false);
    String returnString=await OurDatabase().leaveGroup(gid, currenState.getCurrentUser.uid, currenState.getCurrentUser.fullname);
    if(returnString=="success") {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => OurRoot(),), (
          route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentGroup currentGroup=Provider.of<CurrentGroup>(context,listen: false);
    CurrenState currenState=Provider.of(context,listen: false);
    String uid = currenState.getCurrentUser.uid;
    String gid=currentGroup.getCurrentGroup.id;
    String bid=currentGroup.getCurrentBook.id;
    List<String> names= currentGroup.getCurrentGroup.memebrsNames;
    List<String> namesId= currentGroup.getCurrentGroup.memebrs;

    return (gid!="" && bid!="" && names!=[])? Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Color(0xfff7911e),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Settings','History', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],

        ),

      drawer: Drawer(
        child: Container(
          color: Colors.grey,
          child: Column(
            children: [
              Container(
                color:Colors.white ,
                child: DrawerHeader(
                  child:Container(
                    width: double.infinity,
                    child:Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(currentGroup.getCurrentGroup.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(child: Icon(Icons.share),onTap: (){
                                Clipboard.setData(ClipboardData(text: currentGroup.getCurrentGroup.id))
                                    .then((value) { //only if ->
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Copied Invite Link"),
                                        duration: Duration(seconds: 2),)
                                  );
                                });
                              },),
                              SizedBox(width: 20,),
                              Icon(Icons.door_back_door_sharp),

                            ],
                          )

                        ],
                      ),
                    )

                  ) ,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Group Members" ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    scrollDirection: Axis.vertical,

                    itemBuilder: (context, index){

                      return Column(
                        children: [
                        ListTile(
                          title: Text(names[index]),
                          leading: Icon(namesId[index]==currentGroup.getCurrentGroup.leader? Icons.star:Icons.person),
                          trailing: Visibility(visible: true, child: Icon( Icons.remove_circle,color: Colors.red,))
                          ),
                          Divider(color: Colors.black,)

                      ],
                      );
                    }
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RaisedButton(
                    child: Text("Leave Group",style: TextStyle(color: Colors.red),),
                    color: Colors.black,

                    onPressed: (){
                      leaveGroup(context, gid);

                    }
                ),
              )
            ],
          ),
        ),

      ),


        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('groups').doc((gid))
              .collection("books").doc(bid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot
              ) {
            if( !snapshot.hasData ) {
              return OurSplashScreen();
            }


            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('groups').doc((gid))
                  .collection("books").snapshots(),
                builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2){
                  if( !snapshot2.hasData ) {
                    return OurSplashScreen();
                  }
                  return Column(
                    children: [
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: OurContainer(
                          child: Consumer<CurrentGroup>(

                            builder: (BuildContext context, value, Widget? child) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image(image: NetworkImage(snapshot.data['image'])),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(

                                          children: [
                                            SizedBox(
                                              width: 160,
                                              child: Text((snapshot.data['name']!= "")? snapshot.data['name']: "Loading...",
                                                style: TextStyle(fontSize: 20,color: Colors.grey),maxLines: 2,overflow: TextOverflow.fade,softWrap: false,),
                                            ),
                                            Text((snapshot.data['author']!= "")? snapshot.data['author']: "Loading...",
                                              style: TextStyle(fontSize: 16,color: Colors.grey),),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Row(
                                      children: [
                                        Text("Due In:",style: TextStyle(fontSize: 20,color: Colors.grey),),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text((timeUntil[0]!=null)?timeUntil[0]:"Loading...",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),softWrap: false,maxLines: 2,overflow: TextOverflow.fade,),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RaisedButton(
                                        onPressed: (){
                                        },
                                        child: Text("Read",style: TextStyle(color: Colors.white),),
                                      ),
                                      RaisedButton(
                                        onPressed: (){

                                          value.getDoneWithCurrentBook? null: goToReview(context);
                                        },
                                        child: Text("Finished Book",style: TextStyle(color: Colors.white),),
                                      )
                                    ],
                                  )


                                ],
                              );
                            },

                          ),
                        ),
                      ),
                      Text("Current Books",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot2.data?.docs.length,
                            scrollDirection: Axis.vertical,

                            itemBuilder: (context, index){
                              final document = snapshot2.data?.docs[index];

                              if(document!=null){
                                return HomeBooks(name: document["name"], author: document["author"],pages: document["length"],
                                  categories: [""],image: document["image"],gid: currentGroup.getCurrentGroup.id,bid: document.id,);
                              }

                              return HomeBooks(name: "", author: "",pages: "0",
                                categories: [""],image: "",gid: "",bid: "",
                              );
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                        child: RaisedButton(
                          onPressed: (){
                            goToAddBook(context);
                          },
                          child: Text("Add Book",
                            style: TextStyle(color: Colors.white),),
                        ),
                      ),



                    ],
                  );
                }
            );
          },

        )
    ):OurSplashScreen();
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        signOut(context);
        break;
      case 'Settings':
        break;
    }
  }
}
