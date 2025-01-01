import 'package:flutter/material.dart';

class StiffScrollPhysics extends ScrollPhysics {
  const StiffScrollPhysics({super.parent});

  @override
  StiffScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return StiffScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 20,     // Increase for more "weight" feeling
    stiffness: 300, // Increase for more resistance
    damping: 0.5,    // Increase for less "bounce"
  );
}