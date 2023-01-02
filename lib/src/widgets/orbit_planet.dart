import 'dart:math';

import 'package:flutter/material.dart';

class OrbitPlanet extends StatefulWidget {
  Color? principalColor;
  bool hasOneSatelite;
  OrbitPlanet({super.key, this.principalColor, this.hasOneSatelite = false});

  @override
  State<OrbitPlanet> createState() => _OrbitPlanetState();
}

class _OrbitPlanetState extends State<OrbitPlanet>
    with TickerProviderStateMixin {
  late AnimationController _rotatePlanetController;
  late Animation<double> _animationFirstPlanet;
  late Animation<double> _animationSecondPlanet;

  @override
  void initState() {
    super.initState();
    _rotatePlanetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _animationFirstPlanet =
        Tween<double>(begin: 0, end: 2 * pi).animate(_rotatePlanetController);

    _animationSecondPlanet =
        Tween<double>(begin: pi, end: 3 * pi).animate(_rotatePlanetController);

    _rotatePlanetController.repeat();
  }

  @override
  void dispose() {
    _rotatePlanetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.principalColor,
          ),
        ),
        widget.hasOneSatelite
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                child: AnimatedBuilder(
                  animation: _rotatePlanetController,
                  builder: (context, child) {
                    return Transform.translate(
                        offset: Offset(
                          cos(_animationFirstPlanet.value) * 24,
                          sin(_animationFirstPlanet.value) * 24,
                        ),
                        child: child);
                  },
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0),
          child: AnimatedBuilder(
            animation: _rotatePlanetController,
            builder: (context, child) {
              return Transform.translate(
                  offset: Offset(
                    cos(_animationSecondPlanet.value) * 24,
                    sin(_animationSecondPlanet.value) * 24,
                  ),
                  child: child);
            },
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
