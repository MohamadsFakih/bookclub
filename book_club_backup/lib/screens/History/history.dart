import 'package:book_club/widgets/HistoryBooks.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/HomeBooks.dart';

class OurHistory extends StatefulWidget {
  final String gid;
  const OurHistory({Key? key,required this.gid}) : super(key: key);

  @override
  State<OurHistory> createState() => _OurHistoryState();
}

class _OurHistoryState extends State<OurHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').doc((widget.gid))
            .collection("Fbooks").snapshots(),
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2){
          return Scaffold(

            appBar: AppBar(
              title: Text("Finished Books",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              centerTitle: true,
              backgroundColor: Color(0xfff73366ff),
              elevation: 0.0,
              leading: IconButton(icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                },),
            ),

            body: Column(
              children: [
                SizedBox(height: 20,),

                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot2.data?.docs.length,
                      scrollDirection: Axis.vertical,

                      itemBuilder: (context, index){
                        final document = snapshot2.data?.docs[index];

                        if(document!=null){
                          return HistoryBooks(name: document["name"], author: document["author"],pages: document["length"],
                            categories: [""],image: document["image"],gid: widget.gid,bid: document.id,);
                        }

                        return const Center(child: LinearProgressIndicator());
                      }
                  ),
                )

              ],
            ),
          );
        } ,

      ),
    );
  }
}
