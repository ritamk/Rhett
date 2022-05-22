import 'package:rhett/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? sharedPreferences;
  static const String _loggedInKey = "loggedInKey";
  static const String _userKey = "UserKey";
  static const String _docKey = "DocKey";

  static Future init() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  static Future setUser(UserModel? userModel) async {
    if (userModel != null) {
      try {
        await sharedPreferences!.setStringList(
          _userKey,
          [
            userModel.uid,
            userModel.name ?? "",
            userModel.email ?? "",
          ],
        );
      } catch (e) {
        print("setUser: ${e.toString()}");
        Future.error("Something went wrong while"
            "\nsaving user data on device");
      }
    } else {
      await sharedPreferences!.setStringList(
        _userKey,
        [],
      );
    }
  }

  static UserModel? getUser() {
    try {
      List<String?>? details = sharedPreferences!.getStringList(_userKey);
      return details != null
          ? details.isNotEmpty
              ? UserModel(
                  uid: details[0] ?? "",
                  name: details[1],
                  email: details[2],
                )
              : null
          : null;
    } catch (e) {
      return null;
    }
  }

  static Future setDoc(DocModel? docModel) async {
    if (docModel != null) {
      try {
        await sharedPreferences!.setStringList(
          _docKey,
          [
            docModel.uid,
            docModel.name ?? "",
            docModel.type ?? "",
            docModel.email ?? "",
          ],
        );
      } catch (e) {
        print("setDoc: ${e.toString()}");
        Future.error("Something went wrong while"
            "\nsaving user data on device");
      }
    } else {
      await sharedPreferences!.setStringList(
        _docKey,
        [],
      );
    }
  }

  static DocModel? getDoc() {
    try {
      List<String?>? details = sharedPreferences!.getStringList(_docKey);
      return details != null
          ? details.isNotEmpty
              ? DocModel(
                  uid: details[0] ?? "",
                  name: details[1],
                  type: details[2],
                  email: details[3],
                )
              : null
          : null;
    } catch (e) {
      return null;
    }
  }

  static Future setLoggedIn(bool bool) async {
    try {
      await sharedPreferences!.setBool(
        _loggedInKey,
        bool,
      );
    } catch (e) {
      print("setLoggedInOrNot: ${e.toString()}");
      Future.error("Something went wrong while"
          "\nsaving user data on device");
    }
  }

  static bool getLoggedIn() {
    try {
      return sharedPreferences!.getBool(_loggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }
}
