import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? name;
  final GeoPoint? loc;
  final String? email;
  final String? phone;

  UserModel({
    required this.uid,
    this.name,
    this.loc,
    this.email,
    this.phone,
  });
}

class DocModel {
  final String uid;
  final String? name;
  final String? type;
  final GeoPoint? loc;
  final String? email;
  final String? phone;

  DocModel({
    required this.uid,
    this.name,
    this.type,
    this.loc,
    this.email,
    this.phone,
  });
}
