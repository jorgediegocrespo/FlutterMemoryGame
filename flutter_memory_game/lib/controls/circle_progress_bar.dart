import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgessBar extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final double lineWidth;
  final double progressPercentage;
  final Color progressColor;
  final Color backgroundColor;

  CircleProgessBar({
    required this.lineWidth,
    required this.progressPercentage,
    required this.progressColor,
    required this.backgroundColor,
  }) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = lineWidth;
    _paintBackground.isAntiAlias = true;
    _paintBackground.strokeCap = StrokeCap.round;

    _paintLine.color = progressColor;
    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineWidth;
    _paintBackground.isAntiAlias = true;
    _paintLine.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double fullRadian = 2 * pi;
    double progressRadian = fullRadian * progressPercentage / 100;
    double startRadian = fullRadian * 75 / 100;

    _drawCricle(canvas, size, _paintBackground, startRadian, fullRadian);
    _drawCricle(canvas, size, _paintLine, startRadian, progressRadian);

  }

  void _drawCricle(Canvas canvas, Size size, Paint paint, double startRadian, double progressRadian) {
    

    final minSize = min(size.width, size.height);
    Rect rect = Rect.fromLTRB(lineWidth, lineWidth, minSize - lineWidth, minSize - lineWidth);
    Path path = Path();
    path.addArc(rect, startRadian, progressRadian);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
