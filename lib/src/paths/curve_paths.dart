import 'dart:math';

import 'package:flutter/material.dart';

class CurvePaths {
  /// Generates a circle path centered at [center] with given [radius].
  static Path circular({
    required Offset center,
    required double radius,
  }) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  /// Generates an elliptical path centered at [center]
  /// with horizontal radius [radiusX] and vertical radius [radiusY].
  static Path elliptical({
    required Offset center,
    required double radiusX,
    required double radiusY,
  }) {
    return Path()
      ..addOval(Rect.fromCenter(
          center: center,
          width: radiusX * 2,
          height: radiusY * 2));
  }

  /// Generates a spiral path starting from [center]
  /// going outwards with [turns] and [maxRadius].
  static Path spiral({
    required Offset center,
    required int turns,
    required double maxRadius,
    int pointsPerTurn = 100,
  }) {
    final path = Path();
    final totalPoints = turns * pointsPerTurn;
    for (int i = 0; i <= totalPoints; i++) {
      final t = i / pointsPerTurn; // turn count
      final angle = 2 * pi * t;
      final radius = maxRadius * (t / turns);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  /// Generates a sine wave path starting from [start] to [end]
  /// with vertical amplitude [amplitude] and wave frequency [frequency].
  static Path wave({
    required Offset start,
    required Offset end,
    required double amplitude,
    required double frequency,
    int segments = 200,
  }) {
    final path = Path();
    final dx = (end.dx - start.dx) / segments;
    for (int i = 0; i <= segments; i++) {
      final x = start.dx + dx * i;
      final y = start.dy + amplitude * sin(2 * pi * frequency * (i / segments));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }
}
