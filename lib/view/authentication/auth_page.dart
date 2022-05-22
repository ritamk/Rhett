import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rhett/controller/providers.dart';
import 'package:rhett/shared/constants.dart';
import 'package:rhett/view/authentication/signin_page.dart';
import 'package:rhett/view/authentication/signup_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer(builder: (context, ref, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: const Text("Authentication"),
            bottom: !ref.watch(authSignInProv)
                ? TabBar(
                    tabs: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              FontAwesomeIcons.userLarge,
                              size: 18.0,
                            ),
                            SizedBox(height: 5.0, width: 0.0),
                            Text("User"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              FontAwesomeIcons.userDoctor,
                              size: 18.0,
                            ),
                            SizedBox(height: 5.0, width: 0.0),
                            Text("Doctor"),
                          ],
                        ),
                      ),
                    ],
                    onTap: (index) => ref.read(docAuthProv.state).state =
                        index == 0 ? false : true,
                    indicatorWeight: 3.0,
                  )
                : const PreferredSize(
                    child: SizedBox(height: 0.0, width: 0.0),
                    preferredSize: Size.zero),
          ),
          body: Padding(
            padding: pagePadding,
            child: ref.watch(authSignInProv)
                ? const SignInPage()
                : const SignUpPage(),
          ),
        );
      }),
    );
  }
}
