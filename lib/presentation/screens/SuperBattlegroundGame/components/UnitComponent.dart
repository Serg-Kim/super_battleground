import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class UnitComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  late TimerComponent nextPositionCreator;
  late double unitAngle;
  late Vector2 nextPosition;
  late Vector2 nextPositionDif;
  late String type;
  late String dir;
  late double speed;

  UnitComponent(this.type)
      : super(
    size: Vector2(50, 75),
    position: Vector2(0, 0),
    anchor: Anchor.center,
  );


  void setPosition(Vector2 vec) {
    var difPos = vec - super.position;
    nextPosition = vec;
    nextPositionDif = difPos;
    updateUnitAngle();
    nextPositionCreator.timer.start();
  }

  void updateUnitAngle() {
    bool isPos = nextPositionDif.x > 0;
    double angle = Vector2(0, -1).angleTo(nextPositionDif);

    if (angle > 0) {
      unitAngle = isPos ? angle: -angle;
    }
  }

  Vector2 getBaseUnitVector() {
    return Vector2(sin(unitAngle), -cos(unitAngle));
  }

  void moveTo(Vector2 vec) {
    var difPos = vec - super.position;
    if (difPos.x > 0 && dir != "R") {
      super.flipHorizontally();
      dir = "R";
    }
    if (difPos.x < 0 && dir != "L") {
      super.flipHorizontally();
      dir = "L";
    }

    nextPosition = vec;
    nextPositionDif = difPos;
    updateUnitAngle();
    nextPositionCreator.timer.start();
  }

  void _move() {
    position = nextPositionDif / 10 + nextPosition;
  }


  @override
  Future<void> onLoad() async {
    speed = 1;
    add(
      nextPositionCreator = TimerComponent(
        period: 0.01,
        repeat: true,
        autoStart: false,
        onTick: _move,
      ),
    );
    add(CircleHitbox());
    dir = "R";
    nextPosition = position;
    nextPositionDif = Vector2(0, 0);
    animation = await gameRef.loadSpriteAnimation(
      'characters/$type.png',
      SpriteAnimationData.sequenced(
        stepTime: 1,
        amount: 1,
        textureSize: Vector2(32, 39),
      ),
    );
  }


  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {

    var pos = nextPositionDif * 3;
    nextPositionDif = Vector2(0, 0);
    position -= pos;
  }
}