import 'package:flame/components.dart';
import 'package:super_battleground/presentation/screens/SuperBattlegroundGame/components/UnitComponent.dart';

import '../../MyGame/components/BulletComponent.dart';
import '../../MyGame/components/ExplosionComponent.dart';


class WeaponComponent extends SpriteAnimationComponent
    with HasGameRef {
  late TimerComponent atkCreator;
  WeaponComponent();
  late List<Function (Vector2 position, double angle)> subscribers = [
  ];

  @override
  Future<void> onLoad() async {
    add(
      atkCreator = TimerComponent(
        period: 0.20,
        repeat: true,
        autoStart: false,
        onTick: _createAtk,
      ),
    );
  }

  UnitComponent getUnit() {
    return parent as UnitComponent;
  }

  void _createAtk() {
    atk();
  }

  void atk() {
    gameRef.addAll(
      [getUnit().unitAngle].map(
            (angle) => BulletComponent(
          position: getUnit().position + getUnit().getBaseUnitVector() * 50,
          angle: angle,
        ),
      ),
    );
  }

  void addAtkComponent(Vector2 position, double angle) {
    add(BulletComponent(
      position: position,
      angle: angle,
    ));

    for (var fu in subscribers) { fu(position, angle); }
  }

  subscribe(Function (Vector2 position, double angle) onData) {
    subscribers.add(onData);
  }

  void beginAtk() {
    atkCreator.timer.start();
  }

  void stopAtk() {
    atkCreator.timer.pause();
  }

  void takeHit() {
    gameRef.add(ExplosionComponent(position: position));
  }
}