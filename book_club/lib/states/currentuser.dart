import 'package:book_club/models/user.dart';
import 'package:book_club/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


class CurrenState extends ChangeNotifier{
  OurUser currentUser=OurUser(uid: "", email: "", fullname: "", accountCreated: Timestamp.now());



  OurUser get getCurrentUser => currentUser;

  FirebaseAuth auth =FirebaseAuth.instance;

  Future<String> onStartUp() async{
    String retval="error";
      try{
        User firebaseUser = await auth.currentUser!;
        currentUser= await OurDatabase().getUserInfo(firebaseUser.uid);

        if(currentUser!=null){
          retval="success";
        }
      }catch(e){
        print(e.toString());
      }
    return retval;
  }

   Future<String> signOut() async{
     String retval="error";
     try{
       await auth.signOut();
       currentUser=OurUser(uid: "", email: "", fullname: "", accountCreated: Timestamp.now() );
       retval="success";
     }catch(e){
       print(e.toString());
     }
     return retval;
   }

  Future<String> signUpUser(String email,String password,String fullname)async{
   String retval="error";
   OurUser user=OurUser(uid: "", email: "", fullname: "", accountCreated: Timestamp.now());

   try{
      UserCredential authResult= await auth.createUserWithEmailAndPassword(email: email, password: password);
      user.uid=(authResult.user?.uid)!;
      user.email=(authResult.user?.email)!;
      user.fullname=fullname;
      String returnString=await  OurDatabase().createUser(user);
      if(returnString=="success"){
        retval="success";
      }


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
        currentUser= await OurDatabase().getUserInfo((authResult.user?.uid)!);
        print(currentUser.fullname);


        if(currentUser!=null){
          retval="success";
        }


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


     OurUser user=OurUser(uid: "", email: "", fullname: "", accountCreated: Timestamp.now());
     try{


       GoogleSignInAccount? googleUser=await googleSignIn.signIn();
       GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
       final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth?.idToken,accessToken: googleAuth?.accessToken);
       UserCredential authResult = await auth.signInWithCredential(credential) ;

       if((authResult.additionalUserInfo?.isNewUser)!){

         user.uid=(authResult.user?.uid)!;
         user.email=(authResult.user?.email)!;
         user.fullname=(authResult.user?.displayName)!;

         OurDatabase().createUser(user);

       }
      currentUser= await OurDatabase().getUserInfo((authResult.user?.uid)!);

       if(currentUser!=null){
         retval="success";
       }



     }catch(e){
       retval=e.toString();
     }

     return retval;
   }
}