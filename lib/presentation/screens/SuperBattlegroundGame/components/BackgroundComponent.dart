import 'dart:math';

import 'package:flame/components.dart';

import 'TreeComponent.dart';

class BackgroundCreator extends Component with HasGameRef {
  final gapSize = 8;

  late final Sprite sprite;
  Random random = Random();

  BackgroundCreator();

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('tree.png');

    _createInitialStars();
  }

  void _createTreeAt(double x, double y) {
    gameRef.add(TreeComponent(sprite: sprite, position: Vector2(x, y)));
  }

  void _createRowOfTrees(double y) {
    const gapSize = 1;
    final treeGap = gameRef.size.x / gapSize;

    for (var i = 0; i < gapSize; i++) {
      _createTreeAt(
        treeGap * i + (random.nextDouble() * treeGap),
        y + (random.nextDouble() * 20),
      );
    }
  }

  void _createInitialStars() {
    final rows = gameRef.size.y / gapSize;

    for (var i = 0; i < gapSize; i++) {
      _createRowOfTrees(i * rows);
    }
  }
}
