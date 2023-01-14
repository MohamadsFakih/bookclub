import 'package:book_club/models/book.dart';
import 'package:book_club/models/group.dart';
import 'package:book_club/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CurrentGroup extends ChangeNotifier{
  OurGroup currentGroup=OurGroup(name: "", id: "", leader: "", memebrs: [], groupCreated: Timestamp.now(), currentBookDue: Timestamp.now(), currentBookId: "");
  OurBook currentBook=OurBook(id: "", name: "", length: "", dateCompleted: Timestamp.now(),author: "");

  OurGroup get getCurrentGroup =>currentGroup;
  OurBook get getCurrentBook =>currentBook;

  void updateStateFromDatabase(String groupId)async{
    try{
      //get group info from firebase
      //get current book info
      currentGroup=await OurDatabase().getGroupInfo(groupId);
      currentBook=await OurDatabase().getCurrentBook(groupId, currentGroup.currentBookId);
      notifyListeners();
    }catch(e){
      print(e);
    }

  }
}