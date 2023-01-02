import 'package:flutter/material.dart';
import 'package:space_demo/src/models/start.dart';

class StarPainter extends CustomPainter {
  final Animation<double> animationValue;
  final List<Star> stars;
  StarPainter(this.animationValue, this.stars) : super(repaint: animationValue);
  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      if (star.isTwinkling) {
        canvas.drawCircle(
            Offset(
                star.position.dx * size.width, star.position.dy * size.height),
            0.5 + animationValue.value * 0.5,
            Paint()..color = Colors.white);
      } else {
        canvas.drawCircle(
            Offset(
                star.position.dx * size.width, star.position.dy * size.height),
            star.size,
            Paint()..color = Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
