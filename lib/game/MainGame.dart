// ignore: file_names
import 'dart:async';

import 'package:catch_the_balloons/components/background_component.dart';
import 'package:catch_the_balloons/components/character_component.dart';
import 'package:catch_the_balloons/components/falling_component.dart';
import 'package:catch_the_balloons/components/heart_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainGame extends FlameGame with HasCollisionDetection {
  int gameScore = 0;
  double velocity = 4;
  int objectsCount = 4;
  int missedObjects = 0;
  late TextComponent _scoreText;
  late Timer _timer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(BackgroundComponent());
    add(CharacterComponent());

    for (int i = 0; i < objectsCount; i++) {
      add(FallingComponent());
    }

    _scoreText = TextComponent(
        text: "Score: $gameScore",
        position: Vector2(40, 60),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: BasicPalette.white.color))));
    add(_scoreText);
    add(HeartComponent());

    _timer = Timer(30, repeat: true, onTick: () {
      if (velocity < 14) {
        velocity = velocity + 0.5;
        if (velocity % 3 == 0) {
          add(FallingComponent());
          objectsCount += 1;
        }

        if (kDebugMode) {
          print("$objectsCount $velocity");
        }
      }
    });
    _timer.start();
  }

  @override
  void update(dt) {
    super.update(dt);
    _timer.update(dt);
    _scoreText.text = "Score: $gameScore";
  }

  void replay() {
    missedObjects = 0;  
  }

  void reset() {
    gameScore = 0;
    velocity = 4;
    objectsCount = 4;
    missedObjects = 0;
    _timer.reset();
  }

  void displayHearts() {
    int missObj = missedObjects;
    for (int i = 0; i < 5; i++) {
      if (missObj > 0) {
        missObj -= 1;
      } else {}
    }
  }
}
