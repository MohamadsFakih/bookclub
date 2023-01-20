import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup{
  String id;
  String name;
  String leader;
  List<String> memebrs;
  List<String> memebrsNames;
  Timestamp groupCreated;
  String currentBookId;
  Timestamp currentBookDue;
  String bookLink;

  OurGroup({
    required this.name,
    required this.id,
    required this.leader,
    required this.memebrs,
    required this.groupCreated,
    required this.currentBookDue,
    required this.currentBookId,
    required this.memebrsNames,
    required this.bookLink
});
}