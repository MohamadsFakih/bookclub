import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup{
  String id;
  String name;
  String leader;
  List<String> memebrs;
  Timestamp groupCreated;

  OurGroup({
    required this.name,
    required this.id,
    required this.leader,
    required this.memebrs,
    required this.groupCreated
});
}