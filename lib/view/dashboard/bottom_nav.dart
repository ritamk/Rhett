import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/providers.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return BottomNavigationBar(
        backgroundColor: Colors.green,
        fixedColor: Colors.white,
        onTap: (index) {
          setState(() => _selected = index);
          ref.read(bottomNavProv.state).state = index;
        },
        currentIndex: _selected,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Account",
          ),
        ],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.black54,
      );
    });
  }
}
