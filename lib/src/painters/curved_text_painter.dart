import 'dart:ui';

import 'package:flutter/material.dart';

import '../../curved_text_codespark.dart';

class CurvedTextPainter extends CustomPainter {
  final String text;
  final CurvedTextOptions options;
  final CharTapCallback? onCharTap;
  final TextDirection textDirection;

  CurvedTextPainter({
    required this.text,
    required this.options,
    this.onCharTap,
    this.textDirection = TextDirection.ltr,
  });

  late final List<_CharLayout> _charLayouts = [];

  @override
  void paint(Canvas canvas, Size size) {
    final path = _generatePath(size);
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;

    final totalLength = pathMetrics.fold(0.0, (sum, pm) => sum + pm.length);

    final textToRender = options.rtl ? text.split('').reversed.join() : text;
    final textStyle = options.defaultTextStyle;

    // Measure each character width
    final textPainter = TextPainter(textDirection: textDirection);

    // Calculate total text length on path with spacing
    double totalTextWidth = 0;
    List<double> charWidths = [];
    for (final char in textToRender.characters) {
      textPainter.text = TextSpan(text: char, style: textStyle);
      textPainter.layout();
      charWidths.add(textPainter.width);
      totalTextWidth += textPainter.width + options.spacing;
    }
    totalTextWidth -= options.spacing; // No trailing space

    // Start offset on path for centering
    double offsetOnPath = (totalLength - totalTextWidth) / 2;

    // Render each character on path
    double currentPos = offsetOnPath;
    final paint = Paint();
    for (int i = 0; i < textToRender.length; i++) {
      final char = textToRender[i];
      final charWidth = charWidths[i];

      final charCenterPos = currentPos + charWidth / 2;
      final posData = _extractPositionOnPath(pathMetrics, charCenterPos);

      if (posData == null) continue;

      final Offset charPos = posData.position;
      final double tangentAngle = posData.tangent;

      canvas.save();

      // Move to char position
      canvas.translate(charPos.dx, charPos.dy);

      // Rotate to tangent
      canvas.rotate(
        options.clockwise ? tangentAngle : tangentAngle + 3.1415926535,
      );

      // Draw char, offset to center it
      textPainter.text = TextSpan(text: char, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-charWidth / 2, -textPainter.height / 2),
      );

      canvas.restore();

      _charLayouts.add(
        _CharLayout(
          index: i,
          char: char,
          position: charPos,
          angle: tangentAngle,
        ),
      );

      currentPos += charWidth + options.spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CurvedTextPainter oldDelegate) {
    return oldDelegate.text != text || oldDelegate.options != options;
  }

  /// Returns position and tangent angle on path for given distance.
  _PathPosition? _extractPositionOnPath(
    List<PathMetric> metrics,
    double distance,
  ) {
    double accumulated = 0;
    for (final metric in metrics) {
      if (distance <= accumulated + metric.length) {
        final localDistance = distance - accumulated;
        final tangent = metric.getTangentForOffset(localDistance);
        if (tangent == null) return null;
        return _PathPosition(
          position: tangent.position,
          tangent: tangent.angle,
        );
      }
      accumulated += metric.length;
    }
    return null;
  }

  Path _generatePath(Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (options.curveType) {
      case CurveType.circular:
        return CurvePaths.circular(center: center, radius: options.radius);
      case CurveType.elliptical:
        return CurvePaths.elliptical(
          center: center,
          radiusX: options.radius,
          radiusY: options.radius * 0.6,
        );
      case CurveType.spiral:
        return CurvePaths.spiral(
          center: center,
          turns: options.spiralTurns.toInt(),
          maxRadius: options.radius,
        );
      case CurveType.wave:
        return CurvePaths.wave(
          start: Offset(0, center.dy),
          end: Offset(size.width, center.dy),
          amplitude: options.waveAmplitude,
          frequency: 1,
        );
      case CurveType.bezier:
        // For now just a quadratic bezier
        return Path()
          ..moveTo(center.dx - options.radius, center.dy)
          ..quadraticBezierTo(
            center.dx,
            center.dy - options.radius,
            center.dx + options.radius,
            center.dy,
          );
      case CurveType.customPath:
        return options.customPath ?? Path();
    }
  }
}

class _CharLayout {
  final int index;
  final String char;
  final Offset position;
  final double angle;

  _CharLayout({
    required this.index,
    required this.char,
    required this.position,
    required this.angle,
  });
}

class _PathPosition {
  final Offset position;
  final double tangent;

  _PathPosition({required this.position, required this.tangent});
}
