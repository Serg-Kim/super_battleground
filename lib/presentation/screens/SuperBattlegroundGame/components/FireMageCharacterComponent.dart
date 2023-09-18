import 'CharacterComponent.dart';
import 'WeaponComponent.dart';

class FireMageCharacterComponent extends CharacterComponent  {
  String name;
  FireMageCharacterComponent(this.name) : super(name, 'nun', WeaponComponent());
}