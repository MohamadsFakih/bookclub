import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


class CurrenState extends ChangeNotifier{
   late String uid;
   late String email;


   String get getUid => uid;
   String get getEmail =>email;

  FirebaseAuth auth =FirebaseAuth.instance;

  Future<String> signUpUser(String email,String password)async{
   String retval="error";

   try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      retval="success";

   }catch(e){
     retval=e.toString();
   }

   return retval;
  }
  Future<String> loginUser(String email,String password)async{
    String retval="error";

    try{
      UserCredential authResult=await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = authResult.user;
      if(user!=null){
        uid=user.uid;
        email=user.email!;

        retval="success";
      }
    }catch(e){
      retval=e.toString();
    }

    return retval;
  }


   Future<String> loginUserWithGoogle()async{
     String retval="error";
     
     
     GoogleSignIn googleSignIn =GoogleSignIn(
       scopes: [
         'email',
         'https://www.googleapis.com/auth/contacts.readonly',
       ]
     );

     try{
       GoogleSignInAccount? googleUser=await googleSignIn.signIn();
       GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
       final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth?.idToken,accessToken: googleAuth?.accessToken);
       UserCredential authResult = await auth.signInWithCredential(credential) ;
       final user = authResult.user;
       if(user!=null){
         uid=user.uid;
         email=user.email!;

         retval="success";
       }
     }catch(e){
       retval=e.toString();
     }

     return retval;
   }
}