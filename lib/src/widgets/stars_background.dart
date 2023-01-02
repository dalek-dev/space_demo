import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_demo/src/models/start.dart';
import 'package:space_demo/src/utils/star_painter.dart';

class StarsBackground extends StatefulWidget {
  @override
  State<StarsBackground> createState() => _StarsBackgroundState();
}

class _StarsBackgroundState extends State<StarsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  var stars = <Star>[];
  var rng = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
      reverseDuration: const Duration(milliseconds: 7000),
    );
    _animation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.easeInOutCubic));

    _animationController.repeat(reverse: true);
    for (var i = 0; i < 80; i++) {
      var radius = rng.nextDouble();
      var position = Offset(rng.nextDouble(), rng.nextDouble());
      var isTwinkling = rng.nextBool();
      stars.add(Star(position, radius, isTwinkling));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(_animation, stars),
          child: Container(),
        );
      },
    );
  }
}
