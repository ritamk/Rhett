import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Scaffold background color
const Color scaffoldBGCol = Color.fromARGB(255, 234, 234, 234);

/// Unexpected error message
const String sthWentWrong = "Something went wrong\nPlease try again";

/// Basic minimum padding for every page
const EdgeInsetsGeometry pagePadding = EdgeInsets.all(24.0);

/// Physics for bouncing scroll animation
const ScrollPhysics bouncingPhysics =
    BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

/// Material button style in AuthPage
class AuthMatBtn {
  static const double rad = 10.0;
  static const ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
    topLeft: Radius.circular(rad),
    topRight: Radius.circular(rad),
    bottomLeft: Radius.circular(rad),
    bottomRight: Radius.circular(rad),
  ));
  static const Brightness brightness = Brightness.dark;
  static const EdgeInsetsGeometry padding =
      EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0);
  static const Color color = Colors.green;
}

/// AuthPage text input decoration
InputDecoration authInputDec(String label, Icon prefixIcon) {
  return InputDecoration(
    label: Text(label),
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}

/// Cupertino loading icon
class Loading extends StatelessWidget {
  const Loading({Key? key, required this.white, this.rad}) : super(key: key);
  final bool white;
  final double? rad;

  @override
  Widget build(BuildContext context) {
    return white
        ? Theme(
            data: ThemeData.dark(), child: const CupertinoActivityIndicator())
        : Theme(
            data: ThemeData.fallback(),
            child: CupertinoActivityIndicator(radius: rad ?? 10.0));
  }
}

/// Floating, rounded-bordered snackbar
ScaffoldFeatureController commonSnackbar(String text, BuildContext context,
    {double textSize = 16.0}) {
  const double rad = 15.0;
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(fontSize: textSize),
    ),
    padding: const EdgeInsets.all(18.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rad)),
  ));
}
