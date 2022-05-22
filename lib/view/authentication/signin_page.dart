import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/auth_controller.dart';
import 'package:rhett/controller/firestore_controller.dart';
import 'package:rhett/controller/providers.dart';
import 'package:rhett/controller/shared_pref.dart';
import 'package:rhett/model/user_model.dart';
import 'package:rhett/shared/constants.dart';
import 'package:rhett/view/dashboard/home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();

  bool _hidePass = true;
  bool _signingIn = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                focusNode: _emailNode,
                decoration: authInputDec("Email", const Icon(Icons.email)),
                validator: (val) => !(val != null)
                    ? "Please enter your email"
                    : val.length < 6
                        ? "Email too short"
                        : null,
              ),
              const SizedBox(height: 10.0, width: 0.0),
              TextFormField(
                controller: _passController,
                focusNode: _passNode,
                decoration: InputDecoration(
                  label: const Text("Password"),
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: _hidePass
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () => setState(() => _hidePass = !_hidePass),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                validator: (val) => !(val != null)
                    ? "Please enter a password"
                    : val.length < 6
                        ? "Password too short"
                        : null,
                obscureText: _hidePass,
              ),
              const SizedBox(height: 10.0, width: 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have an account? ",
                      style: TextStyle(color: Colors.black54)),
                  Consumer(builder: (context, ref, _) {
                    return InkWell(
                      onTap: () => ref.read(authSignInProv.state).state = false,
                      child: const Text("Sign Up",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20.0, width: 0.0),
              MaterialButton(
                onPressed: () {
                  setState(() => _signingIn = true);
                  signingIn()
                      .whenComplete(() => setState(() => _signingIn = false));
                },
                child: !_signingIn
                    ? const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 18.0),
                      )
                    : const Loading(white: true),
                color: AuthMatBtn.color,
                colorBrightness: AuthMatBtn.brightness,
                shape: AuthMatBtn.shape,
                padding: AuthMatBtn.padding,
              ),
            ],
          ),
        ),
        physics: bouncingPhysics,
      ),
    );
  }

  Future<void> signingIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dynamic result = await AuthController()
            .signIn(_emailController.text, _passController.text);
        if (result != null) {
          UserSharedPreferences.setLoggedIn(true).whenComplete(() async {
            try {
              final UserModel? userModel =
                  await FirestoreController(uid: result).getUserData();
              userModel != null
                  ? UserSharedPreferences.setUser(userModel)
                      .whenComplete(() =>
                          commonSnackbar("Logged in successfully", context))
                      .whenComplete(() => Navigator.of(context)
                          .pushAndRemoveUntil(
                              CupertinoPageRoute(
                                  builder: (context) => const HomeWrapper()),
                              (route) => false))
                  : null;
            } catch (e) {
              try {
                final DocModel? docModel =
                    await FirestoreController(uid: result).getDocData();
                docModel != null
                    ? UserSharedPreferences.setDoc(docModel)
                        .whenComplete(() =>
                            commonSnackbar("Logged in successfully", context))
                        .whenComplete(() => Navigator.of(context)
                            .pushAndRemoveUntil(
                                CupertinoPageRoute(
                                    builder: (context) => const HomeWrapper()),
                                (route) => false))
                    : null;
              } catch (e) {
                commonSnackbar(sthWentWrong, context);
              }
            }
          });
        }
      } catch (e) {
        commonSnackbar(e.toString(), context);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailNode.dispose();
    _passNode.dispose();
    super.dispose();
  }
}
