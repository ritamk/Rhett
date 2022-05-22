import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/shared_pref.dart';
import 'package:rhett/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainTheme(),
      home: const Wrapper(),
    );
  }
}

ThemeData mainTheme() {
  return ThemeData(
    primarySwatch: Colors.green,
    // scaffoldBackgroundColor: scaffoldBGCol,
  );
}
