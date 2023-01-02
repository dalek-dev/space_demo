import 'package:flutter/material.dart';
import 'package:space_demo/src/models/planet.dart';
import 'package:space_demo/src/widgets/astronaut.dart';
import 'package:space_demo/src/widgets/main_title.dart';
import 'package:space_demo/src/widgets/slider_planets.dart';
import 'package:space_demo/src/widgets/stars_background.dart';

final planets = [
  Planet('MARS', Colors.red, false),
  Planet('EARTH', Colors.blue, true),
];

class SpaceScreen extends StatefulWidget {
  const SpaceScreen({super.key});

  @override
  State<SpaceScreen> createState() => _SpaceScreenState();
}

class _SpaceScreenState extends State<SpaceScreen>
    with TickerProviderStateMixin {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }

  void refresh(int childValue) {
    setState(() {
      currentIndex = childValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            StarsBackground(),
            MainTitle(planets, currentIndex: currentIndex),
            Astronaut(currentIndex: currentIndex),
            SliderPlanets(planets, onIndexChanged: refresh)
          ],
        ));
  }
}
