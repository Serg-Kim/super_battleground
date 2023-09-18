import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';


class HPBar extends PositionComponent {
  double maxHP;
  double currentHP;

  HPBar({
    required this.maxHP,
    required this.currentHP,
  });

  @override
  void render(Canvas canvas) {
    double percentage = currentHP / maxHP;
    Paint bgPaint = Paint()..color = Colors.grey;
    canvas.drawRect(Rect.fromPoints(Offset(-20, -5), Offset(70, -10)), bgPaint);
    Paint fillPaint = Paint()..color = Colors.red;
    if (percentage > 0) {
      canvas.drawRect(
        Rect.fromPoints(Offset(-20, -5), Offset(10 + 70 * percentage, -10)),
        fillPaint,
      );
    }
  }


}