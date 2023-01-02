import 'package:flutter/material.dart';

class CustomPageRoute<t> extends PageRoute<t> {
  final Widget child;

  CustomPageRoute(this.child);

  @override
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(seconds: 2);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
