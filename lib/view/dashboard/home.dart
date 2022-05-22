import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/providers.dart';
import 'package:rhett/shared/constants.dart';
import 'package:rhett/view/dashboard/bottom_nav.dart';
import 'package:rhett/view/dashboard/categories.dart';
import 'package:rhett/view/dashboard/doc_tile.dart';
import 'package:rhett/view/profile/profile.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final ScrollController _scrollController = ScrollController();
  bool _bottomBar = true;
  bool _loading = true;

  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(scrollController: _scrollController),
      const ProfilePage(),
    ];
    setState(() => _loading = false);
    _bottomBar = true;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => _bottomBar = false);
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() => _bottomBar = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        final int index = ref.watch(bottomNavProv);
        return !_loading
            ? _pages[index]
            : const Center(child: Loading(white: false, rad: 14.0));
      }),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: _bottomBar ? 90.0 : 0.0,
        child: _bottomBar
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 20),
                height: _bottomBar ? 90.0 : 0.0,
                child: _bottomBar
                    ? Wrap(
                        children: const [
                          HomeBottomNav(),
                        ],
                      )
                    : Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width),
              )
            : Container(
                color: Colors.green, width: MediaQuery.of(context).size.width),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required ScrollController scrollController})
      : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final List<String> _titles = [
      "Home",
      "Profile",
    ];

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        Consumer(builder: (context, ref, _) {
          return SliverAppBar(
            title: Text(_titles[ref.watch(bottomNavProv)]),
            floating: true,
          );
        }),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Categories:",
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: HomeCategoryTab(),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Doctors:",
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ),
        ),
        const DoctorTile(),
      ],
      physics: bouncingPhysics,
    );
  }
}
