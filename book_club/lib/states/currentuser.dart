import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class CurrenState extends ChangeNotifier{
   late String uid;
   late String email;


   String get getUid => uid;
   String get getEmail =>email;

  FirebaseAuth auth =FirebaseAuth.instance;

  Future<bool> signUpUser(String email,String password)async{
   bool retval=false;

   try{
     UserCredential authResult=await auth.createUserWithEmailAndPassword(email: email, password: password);
     if(authResult.user!=null){
       retval=true;
     }
   }catch(e){
     print(e);
   }

   return retval;
  }
  Future<bool> loginUser(String email,String password)async{
    bool retval=false;

    try{
      UserCredential authResult=await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = authResult.user;
      if(user!=null){
        uid=user.uid;
        email=user.email!;

        retval=true;
      }
    }catch(e){
      print(e);
    }

    return retval;
  }
}