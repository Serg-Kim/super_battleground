import 'dart:convert';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:json_patch/json_patch.dart';

import '../../../online/channel.dart';
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

  late Vector2 position;
  late CharacterComponent player;
  late Map<String, CharacterComponent> players;
  late final TextComponent componentCounter;
  late final TextComponent scoreText;
  late final GameConnection connection;
  final id = "test2";
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
    var characterComponents = <String, CharacterComponent>{};
    connection = GameConnection(id, "test4", "base").connect();

    connection.subscribe((state) => {
      state.players.entries.forEach((ent) {
        if (characterComponents[ent.key].runtimeType == Null) {
          var character = CharacterComponent(ent.value.name);
          characterComponents[ent.key] = character;
          add(character);
          if (ent.key == id) {
            camera.followComponent(character);
            player = character;

          }
          character.hpBar.currentHP = ent.value.character.hp.toDouble();
          character.hpBar.maxHP = ent.value.character.maxHp.toDouble();
          character.mpBar.currentMP = ent.value.character.mp.toDouble();
          character.mpBar.maxMP = ent.value.character.maxMp.toDouble();
        }

        characterComponents[ent.key]?.position = Vector2(ent.value.character.x.toDouble(), ent.value.character.y.toDouble());
      })
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
    player?.beginFire();
  }

  @override
  void onPanEnd(_) {
    player?.stopFire();
  }

  @override
  void onPanCancel() {
    player?.stopFire();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.position += info.delta.game;
    connection.move(player.position);
  }

  void increaseScore() {
    score++;
  }
}