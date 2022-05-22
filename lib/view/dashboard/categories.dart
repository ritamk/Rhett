import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhett/controller/providers.dart';
import 'package:rhett/shared/constants.dart';

class HomeCategoryTab extends ConsumerStatefulWidget {
  const HomeCategoryTab({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeCategoryTab> createState() => _HomeCategoryTabState();
}

class _HomeCategoryTabState extends ConsumerState<HomeCategoryTab> {
  final List<String> _docTypes = <String>[
    "All",
    "Psychiatrist",
    "Gynaecologist",
    "Opthalmologist",
    "Pediatrician",
    "Orthopaedician",
  ];
  final List<IconData> _docTypeIcons = <IconData>[
    Icons.medical_information,
    Icons.psychology,
    Icons.pregnant_woman,
    Icons.preview,
    Icons.lunch_dining,
    Icons.elderly,
  ];
  late int _selectedCat = 0;

  final Color _cardShadowCol = Colors.black26.withOpacity(0.2);
  final Color _selectedCardShadowCol = Colors.greenAccent.withOpacity(0.4);

  @override
  void initState() {
    super.initState();
    if (!mounted) setState(() => _selectedCat = ref.watch(categoryIndexProv));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _docTypes.map<Widget>(
            (String e) {
              final int index = _docTypes.indexOf(e);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedCat = index);
                    ref.read(categoryIndexProv.state).state = index;
                  },
                  child: Card(
                    child: Padding(
                      padding: !(e == _docTypes[0])
                          ? const EdgeInsets.all(12.0)
                          : const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                      child: Column(
                        children: <Widget>[
                          !(_selectedCat == index)
                              ? Icon(_docTypeIcons[index],
                                  color: Colors.green.shade600)
                              : Icon(_docTypeIcons[index], color: Colors.white),
                          const SizedBox(height: 5.0, width: 0.0),
                          !(_selectedCat == index)
                              ? Text(e,
                                  style: const TextStyle(color: Colors.black54))
                              : Text(e,
                                  style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    elevation: 8.0,
                    shadowColor: !(_selectedCat == index)
                        ? _cardShadowCol
                        : _selectedCardShadowCol,
                    color:
                        !(_selectedCat == index) ? Colors.white : Colors.green,
                  ),
                ),
              );
            },
          ).toList(),
        ),
        physics: bouncingPhysics,
      ),
    );
  }
}
