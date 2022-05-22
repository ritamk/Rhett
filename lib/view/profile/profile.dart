import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rhett/controller/auth_controller.dart';
import 'package:rhett/controller/firestore_controller.dart';
import 'package:rhett/controller/shared_pref.dart';
import 'package:rhett/model/user_model.dart';
import 'package:rhett/shared/constants.dart';
import 'package:rhett/view/authentication/auth_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  final SizedBox _seperator = const SizedBox(height: 10.0, width: 0.0);
  bool _loadingData = true;
  bool _signingOut = false;
  bool _doc = false;

  UserModel? _userModel;
  DocModel? _docModel;

  @override
  void initState() {
    super.initState();
    _getProfile().whenComplete(() {
      _nameController.text =
          !_doc ? _userModel?.name ?? "" : _docModel?.name ?? "";
      _mailController.text =
          !_doc ? _userModel?.email ?? "" : _docModel?.email ?? "";
    }).whenComplete(() => setState(() => _loadingData = false));
  }

  Future<void> _getProfile() async {
    if (UserSharedPreferences.getUser() != null) {
      _userModel =
          await FirestoreController(uid: UserSharedPreferences.getUser()!.uid)
              .getUserData();
      _doc = false;
    } else if (UserSharedPreferences.getDoc() != null) {
      _docModel =
          await FirestoreController(uid: UserSharedPreferences.getDoc()!.uid)
              .getDocData();
      _doc = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() => _signingOut = true);
              _signOut()
                  .whenComplete(() => setState(() => _signingOut = false));
            },
            icon: !_signingOut
                ? const Icon(Icons.logout)
                : const Loading(white: true),
          ),
        ],
      ),
      body: !_loadingData
          ? CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: pagePadding,
                  sliver: SliverToBoxAdapter(
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration:
                                authInputDec("Name", const Icon(Icons.person)),
                          ),
                          _seperator,
                          TextFormField(
                            controller: _mailController,
                            decoration:
                                authInputDec("Email", const Icon(Icons.email)),
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              physics: bouncingPhysics,
            )
          : const Center(
              child: Loading(white: false, rad: 14.0),
            ),
    );
  }

  Future<void> _signOut() async {
    await AuthController()
        .signOut()
        .whenComplete(() => UserSharedPreferences.setLoggedIn(false))
        .whenComplete(() => UserSharedPreferences.setUser(null))
        .whenComplete(() => UserSharedPreferences.setDoc(null))
        .whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: ((context) => const AuthPage()),
            ),
            (route) => false));
  }
}
