import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../../../online/channel.dart';
import 'components/BackgroundComponent.dart';
import 'components/CharacterComponent.dart';
import 'components/FireMageCharacterComponent.dart';
import 'components/WeaponComponent.dart';

class SuperBattlegroundGame extends FlameGame
    with PanDetector, HasCollisionDetection, DoubleTapDetector {
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
  late Vector2 runVector2;
  final id = "test8";
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
    Flame.device.setLandscape();
    var characterComponents = <String, CharacterComponent>{};
    runVector2 = Vector2(0,0);
    connection = GameConnection(id, "test8", "nun").connect();

    add(
      runCreator = TimerComponent(
        period: 0.01,
        repeat: true,
        autoStart: false,
        onTick: _run,
      ),
    );

    connection.subscribe((state) => {
      state.players.entries.forEach((ent) {
        if (characterComponents[ent.key].runtimeType == Null) {
          var character = FireMageCharacterComponent(ent.value.name);

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
        if (ent.key == id) {
          characterComponents[ent.key]?.setPosition(Vector2(
              ent.value.character.x.toDouble(),
              ent.value.character.y.toDouble()));
        } else {
          characterComponents[ent.key]?.moveTo(Vector2(
              ent.value.character.x.toDouble(),
              ent.value.character.y.toDouble()));
          }
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
  late TimerComponent runCreator;
  @override
  void onPanStart(_) {
    player?.beginFire();
    runVector2 = Vector2(0,0);
    runCreator.timer.start();
    print(_.eventPosition.viewport);
  }

  @override
  void onPanEnd(_) {
    runVector2 = Vector2(0,0);
    runCreator.timer.pause();
    player?.stopFire();
    print("stop");
  }

  @override
  void onPanCancel() {
    // player?.stopFire();
  }

  void _run() {
    // print("_run");
    var pos = player.position + runVector2;
    connection.move(pos);
    player.moveTo(pos);
  }


  @override
  void onPanUpdate(DragUpdateInfo info) {
    double max = 3;
    double sen = 25;
    var newDeltaVec = info.delta.game / sen + runVector2;
    if (newDeltaVec.x > max) {
      newDeltaVec.x = max;
    }
    if (newDeltaVec.y > max) {
      newDeltaVec.y = max;
    }
    if (newDeltaVec.x < -max) {
      newDeltaVec.x = -max;
    }
    if (newDeltaVec.y < -max) {
      newDeltaVec.y = -max;
    }
    runVector2 = newDeltaVec;
    // var pos = player.position + info.delta.game;
    // connection.move(pos);
    // player.setPosition(pos);
  }

  void increaseScore() {
    score++;
  }
}