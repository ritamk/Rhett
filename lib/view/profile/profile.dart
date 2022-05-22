import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/auth_controller.dart';
import 'package:rhett/controller/firestore_controller.dart';
import 'package:rhett/controller/providers.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _locController = TextEditingController();

  final SizedBox _seperator = const SizedBox(height: 10.0, width: 0.0);
  bool _loadingData = true;
  bool _signingOut = false;
  bool _saving = false;
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
      _phoneController.text =
          !_doc ? _userModel?.phone ?? "" : _docModel?.phone ?? "";
      _locController.text = !_doc
          ? "${_userModel?.loc?.latitude}, ${_userModel?.loc?.longitude}"
          : "${_docModel?.loc?.latitude}, ${_docModel?.loc?.longitude}";
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
          ? GestureDetector(
              onTap: () {
                if (primaryFocus != null) {
                  if (primaryFocus!.hasFocus) {
                    FocusScope.of(context).unfocus();
                  }
                }
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: pagePadding,
                    sliver: SliverToBoxAdapter(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              decoration: authInputDec(
                                  "Name", const Icon(Icons.person)),
                              validator: (val) => !(val != null)
                                  ? "Please enter your name"
                                  : val.length < 3
                                      ? "Name too short"
                                      : null,
                              keyboardType: TextInputType.name,
                            ),
                            _seperator,
                            TextFormField(
                              controller: _phoneController,
                              decoration: authInputDec(
                                  "Phone", const Icon(Icons.phone_iphone)),
                              validator: (val) => !(val != null)
                                  ? "Please enter your number"
                                  : val.length != 10
                                      ? "Please enter a valid phone number"
                                      : null,
                              keyboardType: TextInputType.phone,
                            ),
                            _seperator,
                            TextFormField(
                              controller: _mailController,
                              decoration: authInputDec(
                                  "Email", const Icon(Icons.email)),
                              enabled: false,
                            ),
                            _seperator,
                            TextFormField(
                              controller: _locController,
                              decoration: authInputDec(
                                  "Location", const Icon(Icons.location_on)),
                              enabled: false,
                            ),
                            const SizedBox(height: 20.0, width: 0.0),
                            Consumer(builder: (context, ref, _) {
                              return MaterialButton(
                                onPressed: () {
                                  setState(() => _saving = true);
                                  _saveProfile(ref.watch(docAuthProv))
                                      .whenComplete(() =>
                                          setState(() => _saving = false));
                                },
                                child: !_saving
                                    ? const Text(
                                        "Save",
                                        style: TextStyle(fontSize: 18.0),
                                      )
                                    : const Loading(white: true),
                                color: AuthMatBtn.color,
                                colorBrightness: AuthMatBtn.brightness,
                                shape: AuthMatBtn.shape,
                                padding: AuthMatBtn.padding,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                physics: bouncingPhysics,
              ),
            )
          : const Center(
              child: Loading(white: false, rad: 14.0),
            ),
    );
  }

  Future<void> _saveProfile(bool bool) async {
    if (_formKey.currentState!.validate()) {}
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

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    _locController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
