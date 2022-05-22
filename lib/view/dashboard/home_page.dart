import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/providers.dart';
import 'package:rhett/shared/constants.dart';
import 'package:rhett/view/dashboard/categories.dart';
import 'package:rhett/view/dashboard/doc_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required ScrollController scrollController})
      : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<String> _titles = [
      "Home",
      "Profile",
    ];

    return CustomScrollView(
      controller: widget._scrollController,
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
              "Categories",
              style: TextStyle(fontSize: 17.0, color: Colors.black54),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: HomeCategoryTab(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: const <Widget>[
                Text("Doctors",
                    style: TextStyle(fontSize: 17.0, color: Colors.black54)),
                Expanded(child: SizedBox(height: 0.0, width: 0.0)),
                HomeFilter(),
              ],
            ),
          ),
        ),
        const DoctorTile(),
      ],
      physics: bouncingPhysics,
    );
  }
}

class HomeFilter extends StatefulWidget {
  const HomeFilter({Key? key}) : super(key: key);

  @override
  State<HomeFilter> createState() => _HomeFilterState();
}

class _HomeFilterState extends State<HomeFilter> {
  final List<String> _filters = <String>[
    "No order",
    "Sort by name",
    "Sort by distance",
  ];
  String _selected = "No order";

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.filter_alt,
            color: Colors.black45,
          ),
          const SizedBox(width: 5.0, height: 0.0),
          Text(_selected, style: const TextStyle(color: Colors.black45)),
        ],
      ),
      itemBuilder: (context) => _filters
          .map<PopupMenuItem<String>>((e) => PopupMenuItem<String>(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onSelected: (val) => setState(() => _selected = val),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      tooltip: "Sort by",
    );
  }
}
