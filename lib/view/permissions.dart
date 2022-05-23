import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/firestore_controller.dart';
import 'package:rhett/controller/providers.dart';
import 'package:rhett/controller/shared_pref.dart';
import 'package:rhett/shared/constants.dart';
import 'package:rhett/shared/get_location.dart';
import 'package:rhett/view/dashboard/home.dart';

class GetLocationPage extends ConsumerStatefulWidget {
  const GetLocationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GetLocationPage> createState() => _GetLocationPageState();
}

class _GetLocationPageState extends ConsumerState<GetLocationPage> {
  GeoPoint? _geoPoint;

  bool _gettingLoc = true;
  bool _errorGettingLoc = false;
  bool _gotLoc = false;

  bool _doc = false;

  @override
  void initState() {
    super.initState();
    _getProfile().whenComplete(
      () => _getLocation().whenComplete(() => FirestoreController(
              uid: !_doc
                  ? UserSharedPreferences.getUser()!.uid
                  : UserSharedPreferences.getDoc()!.uid)
          .editLocation(_geoPoint!, _doc)),
    );
  }

  Future<void> _getProfile() async {
    if (UserSharedPreferences.getUser() != null) {
      _doc = false;
    } else if (UserSharedPreferences.getDoc() != null) {
      _doc = true;
    }
  }

  Future<void> _getLocation() async {
    try {
      await determinePosition().then((value) {
        _geoPoint = GeoPoint(value.latitude, value.longitude);
        ref.read(geolocationProv.state).state = value;
      }).whenComplete(() => setState(() => _gotLoc = true));
    } catch (e) {
      setState(() => _errorGettingLoc = true);
      commonSnackbar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_gotLoc
        ? Scaffold(
            body: _gettingLoc
                ? const Center(
                    child: Loading(
                      white: false,
                      rad: 14.0,
                    ),
                  )
                : _errorGettingLoc
                    ? const Material(
                        type: MaterialType.canvas,
                        color: Colors.green,
                        child: PermissionPage())
                    : const SizedBox(height: 0.0, width: 0.0),
          )
        : const HomeWrapper();
  }
}

class PermissionPage extends StatelessWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Permissions required:",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30.0, width: 0.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Icon(
                Icons.location_pin,
                color: Colors.white70,
              ),
              SizedBox(width: 10.0, height: 0.0),
              Text(
                "Location",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15.0, width: 0.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Icon(
                Icons.photo_camera,
                color: Colors.white70,
              ),
              SizedBox(width: 10.0, height: 0.0),
              Text(
                "Media",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
