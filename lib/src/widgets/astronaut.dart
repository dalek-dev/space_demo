import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:space_demo/src/utils/generate_sphere_mesh.dart';

class Astronaut extends StatefulWidget {
  int currentIndex;
  Astronaut({this.currentIndex = 0, super.key});

  @override
  State<Astronaut> createState() => _AstronautState();
}

class _AstronautState extends State<Astronaut> with TickerProviderStateMixin {
  late AnimationController _animationAstronautController;
  late AnimationController _animationFirstPlanetController;
  late AnimationController _animationSecondPlanetController;
  late Animation<double> _animationAstronaut;
  late Animation<double> _animationFadeIn;
  late Animation<double> _animationFirstPlanetFadeIn;
  late Animation<double> _animationSecondPlanetFadeIn;
  late Animation<double> _animationFirstPlanet;
  late Animation<double> _animationSecondPlanet;

  late Scene _scene;
  Object? _earth;
  Object? _mars;

  @override
  void initState() {
    _animationAstronautController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
    _animationAstronaut = Tween<double>(begin: pi / 32, end: pi / 16)
        .animate(_animationAstronautController);
    _animationFadeIn = Tween<double>(begin: 0.3, end: 1)
        .animate(_animationAstronautController);

    _animationFirstPlanetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animationSecondPlanetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animationFirstPlanet = Tween<double>(begin: -40, end: 0).animate(
      _animationFirstPlanetController,
    );
    _animationSecondPlanet = Tween<double>(begin: 40, end: 0)
        .animate(_animationSecondPlanetController);
    _animationFirstPlanetFadeIn = Tween<double>(begin: 0, end: 1)
        .animate(_animationFirstPlanetController);
    _animationSecondPlanetFadeIn = Tween<double>(begin: 0, end: 1)
        .animate(_animationSecondPlanetController);

    _animationAstronautController.forward();
    super.initState();
  }

  void generateSphereObject(Object parent, String name, double radius,
      bool backfaceCulling, String texturePath) async {
    final Mesh mesh =
        await generateSphereMesh(radius: radius, texturePath: texturePath);
    parent
        .add(Object(name: name, mesh: mesh, backfaceCulling: backfaceCulling));
    _scene.updateTexture();
  }

  @override
  dispose() {
    _animationAstronautController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationAstronautController,
          builder: (context, child) {
            return Opacity(
              opacity: _animationFadeIn.value,
              child: Transform(
                transform: Matrix4.rotationX(_animationAstronaut.value),
                child: child,
              ),
            );
          },
          child: ShaderMask(
            shaderCallback: (rect) {
              return const RadialGradient(
                radius: 0.5,
                tileMode: TileMode.clamp,
                colors: [Colors.white, Colors.white, Colors.black],
              ).createShader(rect);
            },
            child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 250),
                child: Image.asset('assets/images/astronaut.png')),
          ),
        ),
        Center(
          child: AnimatedBuilder(
            animation: _animationFirstPlanetController,
            builder: (context, child) {
              if (widget.currentIndex == 0) {
                _animationFirstPlanetController.forward();
              } else {
                _animationFirstPlanetController.reverse();
              }
              return Transform.translate(
                offset: Offset(
                  _animationFirstPlanet.value,
                  0,
                ),
                child: Opacity(
                  opacity: _animationFirstPlanetFadeIn.value,
                  child: Transform(
                    transform: Matrix4.rotationX(_animationAstronaut.value),
                    child: child,
                  ),
                ),
              );
            },
            child: ShaderMask(
              shaderCallback: (rect) {
                return const RadialGradient(
                  radius: 0.2,
                  tileMode: TileMode.clamp,
                  colors: [Colors.white, Colors.black],
                ).createShader(rect);
              },
              child: Container(
                child: Cube(
                  onSceneCreated: (scene) {
                    _scene = scene;
                    _scene.camera.position.z = 16;
                    _mars = Object(name: 'mars', scale: Vector3(1.5, 1.5, 1.5));
                    generateSphereObject(_mars!, 'surface', 0.485, true,
                        'assets/images/mars.jpg');

                    _scene.world.add(_mars!);
                  },
                ),
              ),
            ),
          ),
        ),
        Center(
          child: AnimatedBuilder(
            animation: _animationSecondPlanetController,
            builder: (context, child) {
              if (widget.currentIndex == 1) {
                _animationSecondPlanetController.forward();
              } else {
                _animationSecondPlanetController.reverse();
              }
              return Transform.translate(
                offset: Offset(
                  _animationSecondPlanet.value,
                  0,
                ),
                child: Opacity(
                  opacity: _animationSecondPlanetFadeIn.value,
                  child: Transform(
                    transform: Matrix4.rotationX(_animationAstronaut.value),
                    child: child,
                  ),
                ),
              );
            },
            child: ShaderMask(
              shaderCallback: (rect) {
                return const RadialGradient(
                  radius: 0.2,
                  tileMode: TileMode.clamp,
                  colors: [Colors.white, Colors.black],
                ).createShader(rect);
              },
              child: Container(
                child: Cube(
                  onSceneCreated: (scene) {
                    _scene = scene;
                    _scene.camera.position.z = 16;

                    _earth =
                        Object(name: 'earth', scale: Vector3(1.5, 1.5, 1.5));
                    generateSphereObject(_earth!, 'surface', 0.485, true,
                        'assets/images/earth.jpg');

                    _scene.world.add(_earth!);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
