import 'package:flutter/material.dart';
import 'package:rhett/controller/shared_pref.dart';
import 'package:rhett/view/authentication/auth_page.dart';
import 'package:rhett/view/permissions.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserSharedPreferences.getLoggedIn()
        ? const GetLocationPage()
        : const AuthPage();
  }
}
