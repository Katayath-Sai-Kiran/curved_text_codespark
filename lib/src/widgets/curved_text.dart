// ignore_for_file: unused_field

import 'dart:math';

import 'package:curved_text_codespark/curved_text_codespark.dart';
import 'package:flutter/material.dart';

/// Signature for per-character tap callbacks.
typedef CharTapCallback = void Function(int index, String char);

class CurvedText extends StatefulWidget {
  final String text;
  final CurvedTextOptions options;
  final CharTapCallback? onCharTap;
  final Duration animationDuration;
  final Curve animationCurve;
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
  late final AnimationController _animationController;
  late final Animation<double> _animation;

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
    const hitRadius = 20.0;

    for (final layout in _charLayouts) {
      if ((layout.position - tapPos).distance <= hitRadius) {
        widget.onCharTap?.call(layout.index, layout.char);
        break;
      }
    }
  }

  void _updateCharLayout(int index, String char, Offset position) {
    _charLayouts.add(
      _CharLayout(index: index, char: char, position: position, angle: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = 2 * widget.options.radius;
    _charLayouts.clear();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _handleTapDown(details, Size(size, size)),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: InteractiveCurvedTextPainter(
            text: widget.text,
            options: widget.options,
            styleBuilder: widget.styleBuilder,
            onCharTap: widget.onCharTap,
            onCharLayout: _updateCharLayout,
          ),
        ),
      ),
    );
  }
}

class InteractiveCurvedTextPainter extends CustomPainter {
  final String text;
  final CurvedTextOptions options;
  final TextStyle Function(int index, String char)? styleBuilder;
  final void Function(int index, String char)? onCharTap;
  final void Function(int index, String char, Offset position)? onCharLayout;

  InteractiveCurvedTextPainter({
    required this.text,
    required this.options,
    this.styleBuilder,
    this.onCharTap,
    this.onCharLayout,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (text.isEmpty) return;

    final radius = options.radius;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);

    final isClockwise = options.clockwise;
    final spacing = options.spacing;
    final direction = options.rtl ? -1 : 1;

    final characters = text.characters.toList();
    final anglePerChar = spacing * pi / 180;

    final totalAngle = anglePerChar * characters.length;
    final startAngle = isClockwise ? -totalAngle / 2 : totalAngle / 2;

    for (int i = 0; i < characters.length; i++) {
      final char = characters[i];
      final angle = startAngle + (anglePerChar * i * direction);
      final dx = radius * cos(angle);
      final dy = radius * sin(angle);

      final positionInParent = Offset(dx + center.dx, dy + center.dy);
      onCharLayout?.call(i, char, positionInParent);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle + pi / 2);

      final textStyle = styleBuilder?.call(i, char) ?? options.defaultTextStyle;
      final painter = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final offset = Offset(-painter.width / 2, -painter.height / 2);
      painter.paint(canvas, offset);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
