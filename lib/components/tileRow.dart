import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class TileRow extends StatelessWidget {
  final String title;
  final Widget destination;
  const TileRow({Key? key, required this.title, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 300),
            reverseDuration: Duration(milliseconds: 300),
            child: destination,
          ),
        );
      },
      child: Card(
        color: Color.fromARGB(255, 106, 185, 246),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Text(title),
          )
        ]),
      ),
    );
  }
}
