import 'package:cloud_firestore/cloud_firestore.dart';

class OurBook{
  String id;
  String name;
  String length;
  String author;
  Timestamp dateCompleted;
  String image;

  OurBook({
    required this.id,
    required this.name,
    required this.length,
    required this.dateCompleted,
    required this.author,
    required this.image
});
}