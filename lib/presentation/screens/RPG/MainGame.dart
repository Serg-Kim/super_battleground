import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_isometric/flame_isometric.dart';
import 'package:flame_isometric/custom_isometric_tile_map_component.dart';

import '../../../online/channel.dart';
import '../SuperBattlegroundGame/components/CharacterComponent.dart';
import '../SuperBattlegroundGame/components/FireMageCharacterComponent.dart';

class MainGame extends FlameGame with HasGameRef, PanDetector, HasCollisionDetection, DoubleTapDetector {
  late Vector2 position;
  late CharacterComponent player;
  late Map<String, CharacterComponent> players;
  late final GameConnection connection;
  late Vector2 runVector2;
  final id = "test8";

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final gameSize = gameRef.size;

    final flameIsometric = await FlameIsometric.create(
        tileMap: ['map/grassland_tiles.png'],
        tsxList: ['images/map/grassland.tsx'],
        tmx: 'images/map/grassland_map.tmx'
    );

    for (var renderLayer in flameIsometric.renderLayerList) {
      add(
        CustomIsometricTileMapComponent(
          renderLayer.spriteSheet,
          renderLayer.matrix,
          destTileSize: flameIsometric.srcTileSize,
          position:
          Vector2(gameSize.x / 2, flameIsometric.tileHeight.toDouble()),
        ),
      );
    }

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
          connection.move(character.position = Vector2(300, 300));

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


  }

  @override
  void update(double dt) {
    super.update(dt);
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
}