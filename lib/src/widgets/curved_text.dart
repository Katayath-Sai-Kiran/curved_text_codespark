import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../curved_text_codespark.dart';

typedef CharTapCallback = void Function(int index, String char);

class CurvedText extends StatefulWidget {
  final String text;
  final CurvedTextOptions options;
  final CharTapCallback? onCharTap;
  final Duration animationDuration;
  final Curve animationCurve;

  /// Optional builder for per-character TextStyle customization
  final TextStyle Function(int index, String char)? styleBuilder;

  const CurvedText({
    super.key,
    required this.text,
    this.options = const CurvedTextOptions(),
    this.onCharTap,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeOut,
    this.styleBuilder,
  });

  @override
  State<CurvedText> createState() => _CurvedTextState();
}

class _CurvedTextState extends State<CurvedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  /// Store character layouts from painter for hit testing
  final List<_CharLayout> _charLayouts = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details, Size size) {
    final tapPos = details.localPosition;

    // Hit test which char was tapped
    for (final layout in _charLayouts) {
      // Use a hit radius around char position for easier tap
      const hitRadius = 20.0;
      if ((layout.position - tapPos).distance <= hitRadius) {
        widget.onCharTap?.call(layout.index, layout.char);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) => _handleTapDown(details, constraints.biggest),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _InteractiveCurvedTextPainter(
              text: widget.text,
              options: widget.options,
              animationValue: _animation.value,
              styleBuilder: widget.styleBuilder,
              charLayoutsCallback: (layouts) {
                // Update hit testing layouts
                _charLayouts
                  ..clear()
                  ..addAll(layouts);
              },
            ),
          ),
        );
      },
    );
  }
}

/// Internal painter that supports animation and reports char layouts back to widget
class _InteractiveCurvedTextPainter extends CustomPainter {
  final String text;
  final CurvedTextOptions options;
  final double animationValue;
  final TextStyle Function(int index, String char)? styleBuilder;
  final void Function(List<_CharLayout>) charLayoutsCallback;

  _InteractiveCurvedTextPainter({
    required this.text,
    required this.options,
    required this.animationValue,
    required this.styleBuilder,
    required this.charLayoutsCallback,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // We'll copy and modify CurvedTextPainter's paint logic here with animation & styling

    final path = _generatePath(size);
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;

    final totalLength = pathMetrics.fold(0.0, (sum, pm) => sum + pm.length);

    final textToRender = options.rtl ? text.split('').reversed.join() : text;

    final textPainter = TextPainter(
      textDirection: options.rtl ? TextDirection.rtl : TextDirection.ltr,
    );

    double totalTextWidth = 0;
    List<double> charWidths = [];
    for (final char in textToRender.characters) {
      final style =
          styleBuilder?.call(textToRender.indexOf(char), char) ??
          options.defaultTextStyle;
      textPainter.text = TextSpan(text: char, style: style);
      textPainter.layout();
      charWidths.add(textPainter.width);
      totalTextWidth += textPainter.width + options.spacing;
    }
    totalTextWidth -= options.spacing;

    double offsetOnPath = (totalLength - totalTextWidth) / 2;

    double currentPos = offsetOnPath;
    final List<_CharLayout> layouts = [];

    for (int i = 0; i < textToRender.length; i++) {
      final char = textToRender[i];
      final charWidth = charWidths[i];

      final charCenterPos = currentPos + charWidth / 2;
      final posData = _extractPositionOnPath(pathMetrics, charCenterPos);

      if (posData == null) continue;

      final Offset charPos = posData.position;
      final double tangentAngle = posData.tangent;

      canvas.save();

      // Animation: fade in + slight offset along normal
      final opacity = animationValue.clamp(0.0, 1.0);
      final offsetAnim = 20 * (1 - animationValue);

      // Move to char position + animated offset perpendicular to tangent
      final normal = Offset(-sin(tangentAngle), cos(tangentAngle));
      final animatedPos = charPos + normal * offsetAnim;

      canvas.translate(animatedPos.dx, animatedPos.dy);
      canvas.rotate(
        options.clockwise ? tangentAngle : tangentAngle + 3.1415926535,
      );

      final style = styleBuilder?.call(i, char) ?? options.defaultTextStyle;

      final tp = TextPainter(
        text: TextSpan(
          text: char,
          style: style.copyWith(color: style.color?.withOpacity(opacity)),
        ),
        textDirection: options.rtl ? TextDirection.rtl : TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(-charWidth / 2, -tp.height / 2));

      canvas.restore();

      layouts.add(
        _CharLayout(
          index: i,
          char: char,
          position: charPos,
          angle: tangentAngle,
        ),
      );

      currentPos += charWidth + options.spacing;
    }

    charLayoutsCallback(layouts);
  }

  @override
  bool shouldRepaint(covariant _InteractiveCurvedTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.options != options ||
        oldDelegate.animationValue != animationValue;
  }

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
