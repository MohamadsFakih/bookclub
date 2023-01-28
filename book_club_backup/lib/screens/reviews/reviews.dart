import 'package:book_club/widgets/reviewLine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  final String gid;
  final String bid;
  final String bookName;
  final String image;
  final String author;
  const Reviews({Key? key,
  required this.bid,
    required this.gid,
    required this.bookName,
    required this.image,
    required this.author
  }) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').doc((widget.gid))
            .collection("Fbooks").doc(widget.bid).collection("reviews").snapshots(),
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2){
          return Scaffold(

            appBar: AppBar(
              title: Text("Reviews",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image(image: NetworkImage(widget.image))),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      children: [
                        SizedBox(width: 200,child: Text(widget.bookName,style: TextStyle(fontSize: 20,color: Colors.grey),maxLines: 1,overflow: TextOverflow.fade,softWrap: false,)),
                        Text(widget.author,style: TextStyle(fontSize: 20,color: Colors.grey),maxLines: 1,overflow: TextOverflow.fade,softWrap: false,),

                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),

                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot2.data?.docs.length,
                      scrollDirection: Axis.vertical,

                      itemBuilder: (context, index){
                        final document = snapshot2.data?.docs[index];

                        if(document!=null){
                          return ReviewLine(name: document["from"], review: document["review"], rating: document["rating"], gid: widget.gid, bid: widget.bid);
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
