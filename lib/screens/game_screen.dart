import 'package:catch_the_balloons/game/MainGame.dart';
import 'package:catch_the_balloons/screens/game_over_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';


class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MainGame(),

      overlayBuilderMap: {
        GameOverScreen.ID: (BuildContext context, MainGame gameRef) =>
            GameOverScreen(gameRef: gameRef)
      },
    );
  }
}
