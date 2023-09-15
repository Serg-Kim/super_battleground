import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CharacterComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  late TimerComponent bulletCreator;

var player;

  String name;


  CharacterComponent(String this.name)
      : super(
    size: Vector2(50, 75),
    position: Vector2(0, 0),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    add(TextComponent(text: name));
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