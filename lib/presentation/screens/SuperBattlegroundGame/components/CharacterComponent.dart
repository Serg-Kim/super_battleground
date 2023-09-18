import 'package:flame/components.dart';

import '../../MyGame/components/ExplosionComponent.dart';
import 'HpBarComponent.dart';
import 'MpBarComponent.dart';
import 'UnitComponent.dart';
import 'WeaponComponent.dart';

class CharacterComponent extends UnitComponent  {
  late HPBar hpBar;
  late MPBar mpBar;
  String name;
  late TimerComponent bulletCreator;
  late String dir;
  late WeaponComponent weapon;
  CharacterComponent(this.name, super.type, this.weapon);

  late PolygonComponent hpComponent;

  @override
  Future<void> onLoad() async {
    add(TextComponent(text: name, scale: Vector2(1, 0.8)));
    add(hpBar = HPBar(currentHP: 100, maxHP: 100));
    add(mpBar = MPBar(currentMP: 100, maxMP: 100));
    add(weapon);
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    hit(1);
    super.onCollision(intersectionPoints, other);
  }

  void hit(double dmg) {
    hpBar.currentHP-= dmg;
  }

  void fire() {
    weapon.atk();
  }

  void beginFire() {
    weapon.beginAtk();
  }

  void stopFire() {
    weapon.stopAtk();
  }

  void takeHit() {
    gameRef.add(ExplosionComponent(position: position));
  }
}