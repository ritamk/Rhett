import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Bool to show sign-in page or sign-up
final StateProvider<bool> authSignInProv = StateProvider<bool>((ref) => true);

/// Bool to show sign-up page for doctors or users
final StateProvider<bool> docAuthProv = StateProvider<bool>((ref) => false);

/// Index of what category of doctors the user selectes
final StateProvider<int> categoryIndexProv = StateProvider<int>((ref) => 0);

/// Index of what icon is selected in the bottom bar
final StateProvider<int> bottomNavProv = StateProvider<int>((ref) => 0);

/// Geolocation of the current app cycle
final StateProvider<Position?> geolocationProv =
    StateProvider<Position?>(((ref) => null));
