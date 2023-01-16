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
  Future<String> addBook(String groupId,OurBook book)async {
    String retval = "error";
    try {
      DocumentReference docRef = await firestore.collection("groups").doc(groupId).collection("books").add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted,
        'image':book.image
      });
      //add book to group scehdule
      await firestore.collection("groups").doc(groupId).update({
        'currentBook': docRef.id,
        "currentbookDue":book.dateCompleted
      });
      retval = "success";
    } catch (e) {
      print(e);
    }
    return retval;
  }

  Future<String> addListBook(String groupId,String name,String author,String length,Timestamp date,String img)async {
    String retval = "error";
    try {
      DocumentReference docRef = await firestore.collection("groups").doc(groupId).collection("books").add({
        'name': name,
        'author': author,
        'length': length,
        'dateCompleted': date,
        'image':img
      });
      //add book to group scehdule
      await firestore.collection("groups").doc(groupId).update({
        'currentBook': docRef.id,
        "currentbookDue":Timestamp.fromDate(DateTime(2023,10,24))
      });
      retval = "success";
    } catch (e) {
      print(e);
    }
    return retval;
  }


  Future<String> changeBook(String groupId,String bookId)async {
    String retval = "error";
    try {

      //add book to group scehdule
      await firestore.collection("groups").doc(groupId).update({
        'currentBook': bookId,
      });
      retval = "success";
    } catch (e) {
      print(e);
    }
    return retval;
  }

  Future<String> createGroup(String groupName,String userId,OurBook initialBook,String userName)async{
    String retval="error";
    List<String> members=[];
    List<String> membersNames=[];

    try{
      members.add(userId);
      membersNames.add(userName);
      DocumentReference docRef= await firestore.collection("groups").add({
        'name': groupName,
        'leader':userId,
        'members': members,
        'groupCreated': Timestamp.now(),
        'memberNames':membersNames
      });
      await firestore.collection("users").doc(userId).update({
        'groupId':docRef.id
      });

      //add a book
      addBook(docRef.id,initialBook);

      retval="success";

    }catch(e){
      print(e);
    }
    return retval;
  }
  Future<String> joinGroup(String groupID,String userId,String userName)async{
    String retval="error";
    List<String> members=[];
    List<String> membersNames=[];

    try{
      members.add(userId);
      membersNames.add(userName);
      await firestore.collection("groups").doc(groupID).update({
        'members':FieldValue.arrayUnion(members),
        'memberNames':FieldValue.arrayUnion(membersNames),
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
    OurGroup retVal=OurGroup(name: "", id: "", leader: "", memebrs: [], groupCreated: Timestamp.now(), currentBookDue: Timestamp.now(), currentBookId: "",
    memebrsNames: []);

    try{
      await firestore.collection("groups").doc(groupId).snapshots().listen((event) {
        retVal.id=groupId;
        retVal.name=event.get("name");
        retVal.leader=event.get("leader");
        retVal.memebrs=List<String>.from(event.get("members"));
        retVal.groupCreated=event.get("groupCreated");
        retVal.currentBookId=event.get("currentBook");
        retVal.currentBookDue=event.get("currentbookDue");
        retVal.memebrsNames=List<String>.from(event.get("memberNames"));
      });
    }catch(e){
      print(e);
    }
    return Future.delayed(Duration(seconds: 2), () => retVal);
  }


  Future<OurBook> getCurrentBook(String groupId,String bookId)async{
    OurBook retVal=OurBook(id: "", name: "", length: "", dateCompleted: Timestamp.now(),author: "",image: "");

    try{
      await firestore.collection("groups").doc(groupId).collection("books").doc(bookId).snapshots().listen((event) {
        retVal.id=bookId;
        retVal.name=event.get("name");
        retVal.length=event.get("length").toString();
        retVal.dateCompleted=event.get("dateCompleted");
        retVal.author=event.get("author");
        retVal.image=event.get("image");
      });
    }catch(e){
      print(e);
    }
    return Future.delayed(Duration(seconds: 2), () => retVal);
  }


  Future<String> finishedBook(String groupId,String bookId,String uid,int rating,String review) async{
    String retval="error";
    try{
      await firestore.collection("groups").doc(groupId).collection("books").doc(bookId).collection("reviews").doc(uid).set({
        'rating':rating,
        'review':review,
      });
      retval="success";
    }catch(e){
      print(e);
    }

    return retval;

  }
  Future<bool> isUserDoneWithBook(String groupId,String bookId,String uid)async{
    bool retval=false;
    try{
      await firestore.collection("groups").doc(groupId).collection("books").doc(bookId).collection("reviews").doc(uid).snapshots().listen((event) {
        if(event.exists){
          retval=true;
        }
      });

    }catch(e){

    }

    return retval;
  }


  Future<String> leaveGroup(String groupID,String userId,String userName)async{
    String retval="error";


    try{

      await firestore.collection("groups").doc(groupID).update({
        'members':FieldValue.arrayRemove([userId]),
        'memberNames':FieldValue.arrayRemove([userName]),
      });
      await firestore.collection("users").doc(userId).update({
        'groupId':""
      });

      retval="success";

    }catch(e){
      print(e);
    }
    return retval;
  }




}