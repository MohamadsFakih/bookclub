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
      });
      retval="success";

    }catch(e){
      print(e);
    }
    return retval;
  }


  Future<OurUser> getUserInfo(String uid)async{
    OurUser retVal=OurUser(uid: "", email: "", fullname: "", accountCreated: Timestamp.now());

    try{
      await firestore.collection("users").doc(uid).snapshots().listen((event) {
        retVal.uid=uid;
        retVal.fullname=event.get("fullName");
        retVal.email=event.get("email");
        retVal.accountCreated=event.get("accountCreated");
     
      });


    }catch(e){
      print(e);
    }
    return retVal;

  }
}