// ignore: file_names
import 'dart:async';

import 'package:catch_the_balloons/components/background_component.dart';
import 'package:catch_the_balloons/components/character_component.dart';
import 'package:catch_the_balloons/components/falling_component.dart';
import 'package:catch_the_balloons/components/heart_component.dart';
import 'package:catch_the_balloons/components/pause_button_component.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/screens/game_pause_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainGame extends FlameGame with HasCollisionDetection {
  StreamController onDeactivateController;

  MainGame({required this.onDeactivateController});

  int gameScore = 0;
  double velocity = 4;
  int objectsCount = 4;
  int missedObjects = 0;
  late TextComponent _scoreText;
  late Timer _timer;



  @override
  Future<void> onLoad() async {
    await super.onLoad();


    onDeactivateController.stream.listen((event) {
      if(event && !paused){
        pauseGame();
      }
    });

    add(BackgroundComponent());
    add(PauseButtonComponent());
    add(CharacterComponent());

    for (int i = 0; i < objectsCount; i++) {
      addFallingComponent();
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

    if (LocalData.contains(DatabaseKeys().MUSIC)) {
      if (LocalData.getBool(DatabaseKeys().MUSIC)) {
        FlameAudio.bgm.play('background-music.mp3');
      }
    } else {
      FlameAudio.bgm.play('background-music.mp3');
    }

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
    for (var element in children) {
      if (element is FallingComponent) {
        element.removeFromParent();
      }
    }
    missedObjects = 0;
    resumeEngine();

    for (int i = 0; i < objectsCount; i++) {
      addFallingComponent();
    }

    if (LocalData.contains(DatabaseKeys().MUSIC)) {
      if (LocalData.getBool(DatabaseKeys().MUSIC)) {
        FlameAudio.bgm.play('background-music.mp3');
      }
    } else {
      FlameAudio.bgm.play('background-music.mp3');
    }
  }

  void addFallingComponent() async {
    add(FallingComponent());
  }

  void pauseGame() {
    pauseEngine();
    FlameAudio.bgm.stop();
    overlays.add(GamePauseScreen.ID);
  }

  void resume() {
    overlays.remove(GamePauseScreen.ID);
    if (LocalData.contains(DatabaseKeys().MUSIC)) {
      if (LocalData.getBool(DatabaseKeys().MUSIC)) {
        FlameAudio.bgm.play('background-music.mp3');
      }
    } else {
      FlameAudio.bgm.play('background-music.mp3');
    }
    resumeEngine();
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
