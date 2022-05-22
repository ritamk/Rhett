import 'package:flutter/material.dart';

class DoctorTile extends StatelessWidget {
  const DoctorTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _cardShadowCol = Colors.black26.withOpacity(0.2);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        ((context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    title: Text(index.toString()),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 8.0,
                shadowColor: _cardShadowCol,
              ),
            )),
        childCount: 20,
      ),
    );
  }
}
