import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class TreeComponent extends SpriteComponent with HasGameRef {

  TreeComponent({super.sprite, super.position})
      : super(size: Vector2.all(80));

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (y >= gameRef.size.y || x >= gameRef.size.x) {
      removeFromParent();
    }
  }
}
