import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';


class MPBar extends PositionComponent {
  double maxMP;
  double currentMP;

  MPBar({
    required this.maxMP,
    required this.currentMP,
  });

  @override
  void render(Canvas canvas) {
    double percentage = currentMP / maxMP;
    Paint bgPaint = Paint()..color = Colors.grey;
    canvas.drawRect(Rect.fromPoints(Offset(-20, -3), Offset(70, 2)), bgPaint);
    Paint fillPaint = Paint()..color = Colors.blue;
    if (percentage > 0) {
      canvas.drawRect(
        Rect.fromPoints(Offset(-20, -3), Offset(10 + 70 * percentage, 2)),
        fillPaint,
      );
    }
  }

}