import 'package:book_club/states/currentGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/root/root.dart';
import '../services/database.dart';
import '../states/currentuser.dart';
import 'ourContainer.dart';

class SearchItem extends StatefulWidget {
 final  String name;
 final String author;
 final String pages;
 final List<String> categories;
 final String image;
 final String gid;

  const SearchItem({Key? key,
  required this.name,
    required this.author,
    required this.pages,
    required this.categories,
    required this.image,required this.gid
  }) : super(key: key);

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {

  void addBook(BuildContext context,String groupName,String name,String author,String length,Timestamp date,String img)async{
    String returnString;
    returnString=await OurDatabase().addListBook(groupName, name, author, length, date, img);

    if(returnString=="success"){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot(),), (route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){
          addBook(context, widget.gid, widget.name, widget.author, widget.pages, Timestamp.now(), widget.image.toString());
        },
        child: OurContainer(
            child:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(image: NetworkImage(widget.image),height: 80,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 160, child: Text(widget.name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16),maxLines: 2,overflow: TextOverflow.fade,softWrap: false,)),
                      Text(widget.author,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                      Text(widget.pages.toString()+" Pages",textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.grey),)
                    ],
                  ),
                )

              ],
            ),
            SizedBox(height: 10,),
            Text(widget.categories.toString().replaceAll('[', "").replaceAll(']', ""))
          ],
        )
        ),
      ),
    );;
  }
}
