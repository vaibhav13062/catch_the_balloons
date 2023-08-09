import 'package:catch_the_balloons/constants/globals.dart';
import 'package:catch_the_balloons/game/MainGame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CharacterComponent extends SpriteComponent
    with HasGameRef<MainGame>, DragCallbacks {
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (position.x + event.delta.x < gameRef.size.x - 15 &&
        position.x + event.delta.x > 15) {
      position.x = position.x + event.delta.x;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.character);
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 35);

    height = gameRef.size.x / 5;
    width = gameRef.size.x / 5;

    anchor = Anchor.bottomCenter;
    add(CircleHitbox());
  }
}
