import 'dart:ui';

class Star {
  final Offset position;
  final double size;
  bool isTwinkling;

  Star(this.position, this.size, this.isTwinkling);

  void update() {
    isTwinkling = !isTwinkling;
  }
}
