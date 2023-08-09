import 'package:catch_the_balloons/constants/globals.dart';
import 'package:catch_the_balloons/game/MainGame.dart';
import 'package:flame/components.dart';

class CloudComponent extends SpriteComponent with HasGameRef<MainGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.cloud);
  }
}
