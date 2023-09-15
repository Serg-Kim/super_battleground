import 'dart:ui';

import 'package:flame/collisions.dart';
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
    canvas.drawRect(
      Rect.fromPoints(Offset(-20, -5), Offset(10 + 70 * percentage, -10)),
      fillPaint,
    );
  }

}

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
    canvas.drawRect(
      Rect.fromPoints(Offset(-20, -3), Offset(10 + 70 * percentage, 2)),
      fillPaint,
    );
  }

}

class CharacterComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  late TimerComponent bulletCreator;

var player;
  late HPBar hpBar;
  late MPBar mpBar;
  String name;
  late String dir;

  CharacterComponent(String this.name)
      : super(
    size: Vector2(50, 75),
    position: Vector2(0, 0),
    anchor: Anchor.center,
  );

  late PolygonComponent hpComponent;

  void setPosition(Vector2 vec) {
    var difPos = vec - super.position;
    if (difPos.x > 0 && dir != "R") {
      super.flipHorizontally();
      dir = "R";
    }
    if (difPos.x < 0 && dir != "L") {
      super.flipHorizontally();
      dir = "L";
    }

    super.position = vec;
  }


  @override
  Future<void> onLoad() async {
    Paint grayPaint = Paint()..color = Colors.black;
    add(CircleHitbox());
    add(TextComponent(text: name, scale: Vector2(1, 0.8)));
    add(hpBar = HPBar(currentHP: 0, maxHP: 100));
    add(mpBar = MPBar(currentMP: 100, maxMP: 100));
    dir = "R";

    add(
      bulletCreator = TimerComponent(
        period: 0.05,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
    animation = await gameRef.loadSpriteAnimation(
      'king.png',
      SpriteAnimationData.sequenced(
        stepTime: 1,
        amount: 1,
        textureSize: Vector2(32, 39),
      ),
    );

  }

  final _bulletAngles = [0.5, 0.3, 0.0, -0.5, -0.3];
  void _createBullet() {
    // gameRef.addAll(
    //   _bulletAngles.map(
    //         (angle) => BulletComponent(
    //       position: position + Vector2(-5, -size.y / 2),
    //       angle: angle,
    //     ),
    //   ),
    // );
  }

  void beginFire() {
    bulletCreator.timer.start();
  }

  void stopFire() {
    bulletCreator.timer.pause();
  }

  void takeHit() {
    // gameRef.add(ExplosionComponent(position: position));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    if (true) {
      // other.takeHit();
      print('Hit!');
    }
  }
}