

import 'package:book_club/states/currentGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/root/root.dart';
import '../services/database.dart';
import '../states/currentuser.dart';
import 'ourContainer.dart';

class HomeBooks extends StatefulWidget {
  final  String name;
  final String author;
  final String pages;
  final List<String> categories;
  final String image;
  final String gid;
  final String bid;
  final bool isowner;

  const HomeBooks({Key? key,
    required this.name,
    required this.author,
    required this.pages,
    required this.categories,
    required this.image,
    required this.gid,
    required this.bid,
    required this.isowner
  }) : super(key: key);

  @override
  State<HomeBooks> createState() => HomeBooksState();
}

class HomeBooksState extends State<HomeBooks> {


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: ()async{
          if(widget.isowner){

            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Please Confirm'),
                    content: Text('Are you sure you want to change the current book?'),
                    actions: [
                      // The "Yes" button
                      TextButton(
                          onPressed: ()async {
                            // Remove the box
                            await OurDatabase().changeBook(widget.gid, widget.bid);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Changed book, press Refresh"),
                                  duration: Duration(seconds: 2),)
                            );

                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'))
                    ],
                  );
                });


          }else{
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Only the group admin can change the current boook"),
                  duration: Duration(seconds: 2),)
            );
          }


        },
        child: OurContainer(
            child:
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(10),child: Image(image: NetworkImage(widget.image),height: 80,)),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: 160, child: Text(widget.name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16),maxLines: 2,overflow: TextOverflow.fade,softWrap: false,)),
                          Text(widget.author,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                          Text(widget.pages.toString()+" Pages",textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.grey),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: Icon(Icons.remove_circle,color: Colors.red,),
                                onTap: (){
                                     if(widget.isowner){
                                       showDialog(
                                           context: context,
                                           builder: (BuildContext ctx) {
                                             return AlertDialog(
                                               title: const Text('Please Confirm'),
                                               content: Text('Are you sure to remove'+" "+widget.name+"?"),
                                               actions: [
                                                 // The "Yes" button
                                                 TextButton(
                                                     onPressed: () {
                                                       // Remove the box
                                                       setState(() {
                                                         FirebaseFirestore.instance.collection("groups").doc(widget.gid).collection("books").doc(widget.bid).delete();

                                                       });

                                                       // Close the dialog
                                                       Navigator.of(context).pop();
                                                     },
                                                     child: const Text('Yes')),
                                                 TextButton(
                                                     onPressed: () {
                                                       // Close the dialog
                                                       Navigator.of(context).pop();
                                                     },
                                                     child: const Text('No'))
                                               ],
                                             );
                                           });
                                     }else{
                                       ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(content: Text("Only the group admin can remove books"),
                                             duration: Duration(seconds: 2),)
                                       );
                                     }


                                },
                              )
                            ],
                          )
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
