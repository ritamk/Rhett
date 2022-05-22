import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhett/model/user_model.dart';
import 'package:rhett/shared/constants.dart';

class FirestoreController {
  final String? uid;

  FirestoreController({this.uid});

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("User");

  final CollectionReference _docCollection =
      FirebaseFirestore.instance.collection("Doc");

  Future setUserData(UserModel userModel) async {
    try {
      await _userCollection.doc(uid).set({
        "uid": userModel.uid,
        "name": userModel.name,
        "email": userModel.email,
      });
    } catch (e) {
      print("setUserData: ${e.toString()}");
      throw sthWentWrong;
    }
  }

  Future setDocData(DocModel docModel) async {
    try {
      await _docCollection.doc(uid).set({
        "uid": docModel.uid,
        "name": docModel.name,
        "type": docModel.type,
        "email": docModel.email,
      });
    } catch (e) {
      print("setDocData: ${e.toString()}");
      throw sthWentWrong;
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final dynamic docSnap = await _userCollection.doc(uid).get();
      return UserModel(
        uid: docSnap.data()["uid"],
        name: docSnap.data()["name"],
        email: docSnap.data()["email"],
      );
    } catch (e) {
      print("getUserData: ${e.toString()}");
      throw sthWentWrong;
    }
  }

  Future<DocModel?> getDocData() async {
    try {
      final dynamic docSnap = await _docCollection.doc(uid).get();
      return DocModel(
        uid: docSnap.data()["uid"],
        name: docSnap.data()["name"],
        type: docSnap.data()["type"],
        email: docSnap.data()["email"],
      );
    } catch (e) {
      print("getUserData: ${e.toString()}");
      throw sthWentWrong;
    }
  }
}
