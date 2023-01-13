import 'dart:io';

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
}