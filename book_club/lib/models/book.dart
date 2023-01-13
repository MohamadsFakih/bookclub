import 'package:cloud_firestore/cloud_firestore.dart';

class OurBook{
  String id;
  String name;
  int length;
  Timestamp dateCompleted;

  OurBook({
    required this.id,
    required this.name,
    required this.length,
    required this.dateCompleted
});
}