import 'package:flutter/material.dart';
import 'package:space_demo/src/models/planet.dart';

class MainTitle extends StatelessWidget {
  List<Planet> planets;
  int currentIndex;
  MainTitle(
    this.planets, {
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      alignment: Alignment.topCenter,
      child: RotatedBox(
          quarterTurns: 1,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            switchInCurve: Curves.easeInQuad,
            child: Text(
              key: Key(planets[currentIndex].name),
              planets[currentIndex].name,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 100,
                  color: Colors.white,
                  fontWeight: FontWeight.w100),
            ),
          )),
    );
  }
}
