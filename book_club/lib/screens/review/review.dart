import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/ourContainer.dart';

class OurReview extends StatefulWidget {
  final CurrentGroup currentGroup;
  const OurReview({Key? key,
    required this.currentGroup

  }) : super(key: key);

  @override
  State<OurReview> createState() => _OurReviewState();
}

class _OurReviewState extends State<OurReview> {
   int? dropdownValue=1;
  TextEditingController reviewController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [BackButton()],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: OurContainer(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Rating 1-10"),
                            DropdownButton(
                              value: dropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: <int>[1,2,3,4,5,6,7,8,9,10]
                              .map<DropdownMenuItem<int>>((int value){
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                                }).toList(),
                              onChanged: (newValue){
                                setState((){
                                  dropdownValue=newValue as int;
                                });
                              },
                            )
                          ],
                        ),
                        TextFormField(
                          maxLines: 6,
                          controller: reviewController,
                          decoration: InputDecoration(

                              hintText: "Add a review"
                          ),
                        ),
                        SizedBox(height: 20,),
                        RaisedButton(
                          onPressed: (){
                              String uid=Provider.of<CurrenState>(context,listen: false).getCurrentUser.uid;

                              widget.currentGroup.finishedBook(uid, dropdownValue!, reviewController.text.trim());
                              Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text("Review",style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: 20.0),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );;
  }
}
