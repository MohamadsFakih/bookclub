import 'package:book_club/models/book.dart';
import 'package:book_club/models/group.dart';
import 'package:book_club/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CurrentGroup extends ChangeNotifier{
  OurGroup currentGroup=OurGroup(name: "", id: "", leader: "", memebrs: [], groupCreated: Timestamp.now(), currentBookDue: Timestamp.now(),
      currentBookId: "",memebrsNames: [],bookLink: "");
  OurBook currentBook=OurBook(id: "", name: "", length: "", dateCompleted: Timestamp.now(),author: "",image: "",bookLink: "");
  bool doneWithCurrentBook=false;

  OurGroup get getCurrentGroup =>currentGroup;
  OurBook get getCurrentBook =>currentBook;
  bool get getDoneWithCurrentBook=>doneWithCurrentBook;

  void updateStateFromDatabase(String groupId,String uid)async{
    try{
      //get group info from firebase
      //get current book info
      currentGroup=await OurDatabase().getGroupInfo(groupId);
      currentBook=await OurDatabase().getCurrentBook(groupId, currentGroup.currentBookId);
      doneWithCurrentBook=await OurDatabase().isUserDoneWithBook(groupId, currentGroup.currentBookId,uid);
      notifyListeners();
    }catch(e){
      print(e);
    }

  }

  void finishedBook(String userUid,int rating,String review)async{
    try{
      await OurDatabase().finishedBook(currentGroup.id, currentGroup.currentBookId, userUid, rating, review);
      doneWithCurrentBook=true;
      notifyListeners();
    }catch(e){
      print(e);
    }
  }
}