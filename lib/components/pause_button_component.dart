import 'package:catch_the_balloons/constants/globals.dart';
import 'package:catch_the_balloons/game/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class PauseButtonComponent extends SpriteComponent
    with TapCallbacks, HasGameRef<MainGame> {
  @override
  void onTapDown(TapDownEvent event) {
    gameRef.pauseGame();
    super.onTapDown(event);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.pause_icon);
    position = Vector2(gameRef.size.x - 60, 70);
    height = 50;
    width = 50;
  }
}
