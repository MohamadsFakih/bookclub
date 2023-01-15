import 'dart:async';
import 'dart:io';

import 'package:book_club/screens/addBookScreen/addBook.dart';
import 'package:book_club/screens/bookstest.dart';
import 'package:book_club/screens/noGroup/nogroup.dart';
import 'package:book_club/screens/review/review.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/screens/splashScreen/splash.dart';
import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:book_club/utils/timeleft.dart';
import 'package:book_club/widgets/HomeBooks.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    CurrentGroup currentGroup=Provider.of<CurrentGroup>(context,listen: false);
    String gid=currentGroup.getCurrentGroup.id;
    String bid=currentGroup.getCurrentBook.id;

    return (gid!="" && bid!="")? Scaffold(

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
                      SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.all(20),
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

                                  RaisedButton(
                                    onPressed: (){

                                      value.getDoneWithCurrentBook? null: goToReview(context);
                                    },
                                    child: Text("Finished Book",style: TextStyle(color: Colors.white),),
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
                  );
                }
            );
          },

        )
    ):OurSplashScreen();
  }
}
