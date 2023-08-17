import 'package:catch_the_balloons/ads/ads_provider.dart';
import 'package:catch_the_balloons/game/main_game.dart';
import 'package:catch_the_balloons/screens/game_over_screen.dart';
import 'package:catch_the_balloons/screens/game_pause_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AdsProvider>(context, listen: false).loadRewardedAd();
    Provider.of<AdsProvider>(context, listen: false).loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MainGame(),
      overlayBuilderMap: {
        GameOverScreen.ID: (BuildContext context, MainGame gameRef) =>
            GameOverScreen(
              gameRef: gameRef,
            ),
        GamePauseScreen.ID: (BuildContext context, MainGame gameRef) =>
            GamePauseScreen(gameRef: gameRef),
      },
    );
  }
}
