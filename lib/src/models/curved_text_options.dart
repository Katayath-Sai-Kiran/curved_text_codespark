import 'package:flutter/material.dart';

import 'curve_type.dart';

class CurvedTextOptions {
  final CurveType curveType;
  final double radius;
  final double spacing;
  final bool clockwise;
  final bool rtl;
  final Path? customPath;
  final TextStyle defaultTextStyle;
  final double waveAmplitude;
  final double spiralTurns;

  const CurvedTextOptions({
    this.curveType = CurveType.circular,
    this.radius = 100,
    this.spacing = 0,
    this.clockwise = true,
    this.rtl = false,
    this.customPath,
    this.waveAmplitude = 20,
    this.spiralTurns = 3,
    this.defaultTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  });
}
