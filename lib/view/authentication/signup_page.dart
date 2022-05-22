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

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();

  bool _hidePass = true;
  bool _signingUp = false;

  final List<String> _docTypes = <String>[
    "Psychiatrist",
    "Gynaecologist",
    "Opthalmologist",
    "Pediatrician",
    "Orthopaedician",
  ];
  final List<Icon> _docTypeIcons = const <Icon>[
    Icon(Icons.psychology),
    Icon(Icons.pregnant_woman),
    Icon(Icons.preview),
    Icon(Icons.lunch_dining),
    Icon(Icons.elderly),
  ];
  String _selectedType = "Psychiatrist";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Consumer(builder: (contex, ref, _) {
            return Column(
              children: <Widget>[
                Consumer(builder: (context, ref, _) {
                  return RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 18.0, color: Colors.black54),
                      children: <InlineSpan>[
                        const TextSpan(text: "Registering as: "),
                        TextSpan(
                            text: ref.watch(docAuthProv) ? "Doctor" : "User",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 60.0, width: 0.0),
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameNode,
                  decoration: authInputDec("Name", const Icon(Icons.person)),
                  validator: (val) => !(val != null)
                      ? "Please enter your name"
                      : val.length < 3
                          ? "Name too short"
                          : null,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) =>
                      FocusNode().requestFocus(_emailNode),
                ),
                const SizedBox(height: 10.0, width: 0.0),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailNode,
                  decoration: authInputDec("Email", const Icon(Icons.email)),
                  validator: (val) => !(val != null)
                      ? "Please enter your email"
                      : val.length < 4
                          ? "Email too short"
                          : null,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) =>
                      FocusNode().requestFocus(_passNode),
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
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) =>
                      FocusNode().requestFocus(_emailNode),
                ),
                const SizedBox(height: 10.0, width: 0.0),
                !ref.watch(docAuthProv)
                    ? const SizedBox(height: 0.0, width: 0.0)
                    : DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: _docTypes
                            .map<DropdownMenuItem<String>>(
                              (String e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ),
                            )
                            .toList(),
                        validator: (val) =>
                            !(val != null) ? "Please choose a category" : null,
                        onChanged: (String? val) =>
                            setState(() => _selectedType = val!),
                        decoration: authInputDec("Category",
                            _docTypeIcons[_docTypes.indexOf(_selectedType)]),
                        elevation: 3,
                      ),
                const SizedBox(height: 10.0, width: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.black54)),
                    Consumer(builder: (context, ref, _) {
                      return InkWell(
                        onTap: () =>
                            ref.read(authSignInProv.state).state = true,
                        child: const Text("Sign In",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20.0, width: 0.0),
                MaterialButton(
                  onPressed: () {
                    setState(() => _signingUp = true);
                    signingUp(ref.watch(docAuthProv))
                        .whenComplete(() => setState(() => _signingUp = false));
                  },
                  child: !_signingUp
                      ? const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18.0),
                        )
                      : const Loading(white: true),
                  color: AuthMatBtn.color,
                  colorBrightness: AuthMatBtn.brightness,
                  shape: AuthMatBtn.shape,
                  padding: AuthMatBtn.padding,
                ),
              ],
            );
          }),
        ),
        physics: bouncingPhysics,
      ),
    );
  }

  Future<void> signingUp(bool doc) async {
    if (_formKey.currentState!.validate()) {
      try {
        final dynamic result = await AuthController()
            .signUp(_emailController.text, _passController.text);
        if (result != null) {
          !doc ? setUserData(result) : setDocData(result);
        }
      } catch (e) {
        commonSnackbar(e.toString(), context);
      }
    }
  }

  Future<void> setUserData(dynamic result) async {
    await FirestoreController(uid: result)
        .setUserData(
          UserModel(
            uid: result,
            name: _nameController.text,
            email: _emailController.text,
          ),
        )
        .whenComplete(() => UserSharedPreferences.setUser(UserModel(
              uid: result,
              name: _nameController.text,
              email: _emailController.text,
            )))
        .whenComplete(() => UserSharedPreferences.setLoggedIn(true))
        .whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => const HomeWrapper()),
            (route) => false));
  }

  Future<void> setDocData(dynamic result) async {
    await FirestoreController(uid: result)
        .setDocData(
          DocModel(
            uid: result,
            name: _nameController.text,
            type: _selectedType,
            email: _emailController.text,
          ),
        )
        .whenComplete(() => UserSharedPreferences.setDoc(DocModel(
              uid: result,
              name: _nameController.text,
              type: _selectedType,
              email: _emailController.text,
            )))
        .whenComplete(() => UserSharedPreferences.setLoggedIn(true))
        .whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => const HomeWrapper()),
            (route) => false));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _nameNode.dispose();
    _emailNode.dispose();
    _passNode.dispose();
    super.dispose();
  }
}
