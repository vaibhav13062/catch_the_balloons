import 'package:catch_the_balloons/constants/globals.dart';
import 'package:catch_the_balloons/game/main_game.dart';
import 'package:flame/components.dart';

class BackgroundComponent extends SpriteComponent with HasGameRef<MainGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size = gameRef.size;
  }
}
