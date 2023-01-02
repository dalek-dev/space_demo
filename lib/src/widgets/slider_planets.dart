import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_demo/src/models/planet.dart';
import 'package:space_demo/src/screen/planet_screen.dart';
import 'package:space_demo/src/utils/curved_slider_painter.dart';
import 'package:space_demo/src/utils/custom_page_route.dart';
import 'package:space_demo/src/widgets/orbit_planet.dart';

class SliderPlanets extends StatefulWidget {
  List<Planet> planets;
  Function(int) onIndexChanged;
  SliderPlanets(
    this.planets, {
    required this.onIndexChanged,
    super.key,
  });

  @override
  State<SliderPlanets> createState() => _SliderPlanetsState();
}

class _SliderPlanetsState extends State<SliderPlanets>
    with TickerProviderStateMixin {
  late AnimationController _animationFirstPlanetController;
  late AnimationController _animationSecondPlanetController;
  late Animation<double> _animationFirstPlanet;
  late Animation<double> _animationSecondPlanet;

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _animationFirstPlanetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animationSecondPlanetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
    _animationFirstPlanet = Tween<double>(begin: pi, end: (pi / 2) * 3)
        .animate(_animationFirstPlanetController);
    _animationSecondPlanet = Tween<double>(begin: pi / 2 * 5, end: (pi / 2) * 3)
        .animate(_animationSecondPlanetController);

    _animationFirstPlanetController.forward();
    _animationSecondPlanetController.reverse();
  }

  @override
  void dispose() {
    _animationFirstPlanetController.dispose();
    _animationSecondPlanetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
              painter: SemiCircleSliderPainter(), child: const SizedBox()),
        ),
        Positioned(
          bottom: 130,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 30,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_left_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _animationFirstPlanetController.animateTo(
                      _animationFirstPlanetController.value + pi,
                      curve: Curves.easeInOut,
                    );
                    _animationSecondPlanetController.animateTo(
                      _animationSecondPlanetController.value - pi,
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      currentIndex = 0;
                    });
                    widget.onIndexChanged(currentIndex);
                  },
                ),
              ),
              const SizedBox(
                width: 200,
              ),
              IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  _animationFirstPlanetController.animateTo(
                    _animationFirstPlanetController.value - pi,
                    curve: Curves.easeInOut,
                  );
                  _animationSecondPlanetController.animateTo(
                    _animationSecondPlanetController.value + pi,
                    curve: Curves.easeInOut,
                  );

                  setState(() {
                    currentIndex = 1;
                  });
                  widget.onIndexChanged(currentIndex);
                },
              ),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -57,
          left: size.width / 2 - 15,
          child: AnimatedBuilder(
            animation: _animationFirstPlanetController,
            builder: (context, child) {
              return Transform.translate(
                  offset: Offset(
                    cos(_animationFirstPlanet.value) * (size.width / 2 - 30),
                    sin(_animationFirstPlanet.value) * (size.width / 2),
                  ),
                  child: child);
            },
            child: OrbitPlanet(
              principalColor: widget.planets[0].orbitPlanet,
            ),
          ),
        ),
        Positioned(
          bottom: -57,
          left: size.width / 2 - 15,
          child: AnimatedBuilder(
            animation: _animationSecondPlanetController,
            builder: (context, child) {
              return Transform.translate(
                  offset: Offset(
                    cos(_animationSecondPlanet.value) * (size.width / 2 - 30),
                    sin(_animationSecondPlanet.value) * (size.width / 2),
                  ),
                  child: child);
            },
            child: OrbitPlanet(
              principalColor: widget.planets[1].orbitPlanet,
              hasOneSatelite: widget.planets[1].hasOneOrbitPlanet,
            ),
          ),
        ),
        Positioned(
          bottom: 90,
          right: 0,
          left: 0,
          child: GestureDetector(
            onTap: () {
              if (currentIndex == 1) {
                Navigator.push(
                  context,
                  CustomPageRoute(const PlanetScreen()),
                );
              }
            },
            child: Container(
                alignment: Alignment.center,
                child: Text(widget.planets[currentIndex].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        letterSpacing: 3,
                        color: Colors.white))),
          ),
        )
      ],
    );
  }
}
