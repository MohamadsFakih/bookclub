import 'dart:io';

import 'package:book_club/models/book.dart';
import 'package:book_club/models/group.dart';
import 'package:book_club/screens/noGroup/nogroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class OurDatabase{
  final FirebaseFirestore firestore=FirebaseFirestore.instance;

  Future<String> createUser(OurUser user)async{
    String retval="error";

    try{
      await firestore.collection("users").doc(user.uid).set({
        'fullName':user.fullname,
        'email':user.email,
        'accountCreated':Timestamp.now(),
        'groupId':user.groupId
      });
      retval="success";

    }catch(e){
      print(e);
    }
    return retval;
  }


  Future<OurUser> getUserInfo(String uid)async{
    OurUser retVal=OurUser(uid: "", email: "", fullname: "", accountCreated: Timestamp.now(),groupId: "");

    try{
      await firestore.collection("users").doc(uid).snapshots().listen((event) {
        retVal.uid=uid;
        retVal.fullname=event.get("fullName");
        retVal.email=event.get("email");
        retVal.accountCreated=event.get("accountCreated");
        retVal.groupId=event.get("groupId");
      });
    }catch(e){
      print(e);
    }
    return Future.delayed(Duration(seconds: 2), () => retVal);
  }

  Future<String> createGroup(String groupName,String userId)async{
    String retval="error";
    List<String> members=[];

    try{
      members.add(userId);
      DocumentReference docRef= await firestore.collection("groups").add({
        'name': groupName,
        'leader':userId,
        'members': members,
        'groupCreated': Timestamp.now(),
      });
      await firestore.collection("users").doc(userId).update({
        'groupId':docRef.id
      });
      retval="success";

    }catch(e){
      print(e);
    }
    return retval;
  }
  Future<String> joinGroup(String groupID,String userId)async{
    String retval="error";
    List<String> members=[];

    try{
      members.add(userId);
      await firestore.collection("groups").doc(groupID).update({
        'members':FieldValue.arrayUnion(members)
      });
      await firestore.collection("users").doc(userId).update({
        'groupId':groupID
      });

      retval="success";

    }catch(e){
      print(e);
    }
    return retval;
  }


  Future<OurGroup> getGroupInfo(String groupId)async{
    OurGroup retVal=OurGroup(name: "", id: "", leader: "", memebrs: [], groupCreated: Timestamp.now(), currentBookDue: Timestamp.now(), currentBookId: "");

    try{
      await firestore.collection("groups").doc(groupId).snapshots().listen((event) {
        retVal.id=groupId;
        retVal.name=event.get("name");
        retVal.leader=event.get("leader");
        retVal.memebrs=List<String>.from(event.get("members"));
        retVal.groupCreated=event.get("groupCreated");
        retVal.currentBookId=event.get("currentBookId");
        retVal.currentBookDue=event.get("currentbookDue");
      });
    }catch(e){
      print(e);
    }
    return Future.delayed(Duration(seconds: 2), () => retVal);
  }


  Future<OurBook> getCurrentBook(String groupId,String bookId)async{
    OurBook retVal=OurBook(id: "", name: "", length: 0, dateCompleted: Timestamp.now());

    try{
      await firestore.collection("groups").doc(groupId).collection("books").doc(bookId).snapshots().listen((event) {
        retVal.id=bookId;
        retVal.name=event.get("name");
        retVal.length=event.get("length");
        retVal.dateCompleted=event.get("dateCompleted");
      });
    }catch(e){
      print(e);
    }
    return Future.delayed(Duration(seconds: 2), () => retVal);
  }
}