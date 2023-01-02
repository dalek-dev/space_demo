import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:space_demo/src/utils/generate_sphere_mesh.dart';
import 'package:space_demo/src/widgets/stars_background.dart';

class PlanetScreen extends StatefulWidget {
  const PlanetScreen({super.key});

  @override
  State<PlanetScreen> createState() => _PlanetScreenState();
}

class _PlanetScreenState extends State<PlanetScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationPlanetController;
  late Scene _scene;
  Object? _earth;

  void generateSphereObject(Object parent, String name, double radius,
      bool backfaceCulling, String texturePath) async {
    final Mesh mesh =
        await generateSphereMesh(radius: radius, texturePath: texturePath);
    parent
        .add(Object(name: name, mesh: mesh, backfaceCulling: backfaceCulling));
    _scene.updateTexture();
  }

  void _onSceneCreated(scene) {
    _scene = scene;
    _scene.camera.position.z = 10;

    _earth = Object(name: 'earth', scale: Vector3(10, 10, 10));
    generateSphereObject(
        _earth!, 'surface', 0.485, true, 'assets/images/earth.jpg');

    _scene.world.add(_earth!);
  }

  @override
  initState() {
    _animationPlanetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 70000))
      ..addListener(() {
        if (_earth != null) {
          _earth!.rotation.x = _animationPlanetController.value * -360;
          _earth!.updateTransform();
          _scene.update();
        }
      })
      ..repeat();

    super.initState();
  }

  @override
  dispose() {
    _animationPlanetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            StarsBackground(),
            Positioned(
              bottom: -650,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 900,
                width: 900,
                child: AnimatedBuilder(
                  animation: _animationPlanetController,
                  builder: (context, child) {
                    return Cube(onSceneCreated: _onSceneCreated);
                  },
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ShaderMask(
                    shaderCallback: (rect) {
                      return const RadialGradient(
                        radius: 0.6,
                        tileMode: TileMode.clamp,
                        colors: [Colors.transparent, Colors.black],
                      ).createShader(rect);
                    },
                    child: Container(
                      height: size.height / 2,
                      width: double.infinity,
                      color: Colors.white,
                    ))),
            const Center(
              child: Text(
                'EARTH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w200,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ));
  }
}
