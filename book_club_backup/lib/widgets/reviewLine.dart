import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewLine extends StatelessWidget {
  final String name;
  final String review;
  final double rating;
  final String gid;
  final String bid;
  const ReviewLine({Key? key,
  required this.name,
    required this.review,
    required this.rating,
    required this.gid,
    required this.bid
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8),
    child: OurContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              RatingBarIndicator(
                rating: rating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 30.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text(review,style: TextStyle( fontSize: 18),maxLines: 10,overflow: TextOverflow.ellipsis,),

        ],
      ),
    ),

    );
  }
}
