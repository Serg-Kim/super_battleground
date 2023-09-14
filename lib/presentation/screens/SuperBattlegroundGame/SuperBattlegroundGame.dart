import 'dart:convert';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:json_patch/json_patch.dart';

import 'components/BackgroundComponent.dart';
import 'components/CharacterComponent.dart';

class Player {
  late int x;
  late int y;
}

class SuperBattlegroundGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  static const String description = '''
    A simple space shooter game used for testing performance of the collision
    detection system in Flame.
  ''';

  late final CharacterComponent player;
  late final TextComponent componentCounter;
  late final TextComponent scoreText;
  final id = "test";
  int score = 0;

  // final cameraComponent = CameraComponent.withFixedResolution(
  //   width: 5000,
  //   height: 5000,
  // );

  var gameState;

  @override
  Color backgroundColor() => const Color(0xFF55C47D);

  @override
  Future<void> onLoad() async {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.100.22:8080/echo?id=${id}'),
    );

    channel.stream.listen((message) {
      var data = json.decode(message);

      print(data);
      if (data.runtimeType == List<dynamic>) {
        final patches = (data as Iterable).map((e) => e as Map<String, dynamic>);

        gameState = JsonPatch.apply(gameState, patches, strict: false);

        add(player = CharacterComponent(player: gameState["players"][this.id]));
        camera.followComponent(player);
        return;
      }
        gameState = data;
    });


    addAll([
      FpsTextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
      ),
      scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      componentCounter = TextComponent(
        position: size,
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
    ]);

    // add(EnemyCreator());
    add(BackgroundCreator());
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = 'Score: $score';
    componentCounter.text = 'Components: ${children.length}';
  }

  @override
  void onPanStart(_) {
    player.beginFire();
  }

  @override
  void onPanEnd(_) {
    player.stopFire();
  }

  @override
  void onPanCancel() {
    player.stopFire();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.position += info.delta.game;
  }

  void increaseScore() {
    score++;
  }
}