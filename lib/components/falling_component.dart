import 'dart:math';

import 'package:catch_the_balloons/components/character_component.dart';
import 'package:catch_the_balloons/game/main_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants/globals.dart';

class FallingComponent extends SpriteComponent
    with HasGameRef<MainGame>, CollisionCallbacks {
  final Random random = Random();

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is CharacterComponent) {
      removeFromParent();
      gameRef.gameScore += 1;
      gameRef.add(FallingComponent());
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.waterDroplet2);
    height = gameRef.size.x / 12;
    width = gameRef.size.x / 12;

    position = Vector2(_getRandomXPos(), 50);

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += gameRef.velocity;

    if (y > gameRef.size.y - 15) {
      removeFromParent();
      gameRef.missedObjects += 1;
      gameRef.add(FallingComponent());
    }
  }

  double _getRandomXPos() {
    double x = random.nextInt(gameRef.size.x.toInt() - 30).toDouble();
    return x;
  }
}
