import 'package:catch_the_balloons/constants/globals.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/game/main_game.dart';
import 'package:catch_the_balloons/screens/game_over_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';

enum HeartState {
  five,
  four,
  three,
  two,
  one,
  zero,
}

class HeartComponent extends SpriteGroupComponent<HeartState>
    with HasGameRef<MainGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    Sprite fiveHearts = await gameRef.loadSprite(Globals.heart5);
    Sprite fourHearts = await gameRef.loadSprite(Globals.heart4);
    Sprite threeHearts = await gameRef.loadSprite(Globals.heart3);
    Sprite twoHearts = await gameRef.loadSprite(Globals.heart2);
    Sprite oneHearts = await gameRef.loadSprite(Globals.heart1);
    Sprite zeroHearts = await gameRef.loadSprite(Globals.heart0);

    sprites = {
      HeartState.five: fiveHearts,
      HeartState.four: fourHearts,
      HeartState.three: threeHearts,
      HeartState.two: twoHearts,
      HeartState.one: oneHearts,
      HeartState.zero: zeroHearts,
    };

    width = 170;
    height = 170 / 5;
    position = Vector2(37, 90);
    current = HeartState.five;
  }

  @override
  void update(dt) {
    super.update(dt);
    if (gameRef.missedObjects == 0) {
      current = HeartState.five;
    } else if (gameRef.missedObjects == 1) {
      current = HeartState.four;
    } else if (gameRef.missedObjects == 2) {
      current = HeartState.three;
    } else if (gameRef.missedObjects == 3) {
      current = HeartState.two;
    } else if (gameRef.missedObjects == 4) {
      current = HeartState.one;
    } else if (gameRef.missedObjects >= 5) {
      current = HeartState.zero;
      gameRef.pauseEngine();
      gameRef.overlays.add(GameOverScreen.ID);
      if (LocalData.contains(DatabaseKeys().HIGH_SCORE)) {
        if (LocalData.getInt(DatabaseKeys().HIGH_SCORE) <= gameRef.gameScore) {
          LocalData.saveInt(DatabaseKeys().HIGH_SCORE, gameRef.gameScore);
          saveHighScoreOnServer(gameRef.gameScore);
        }
      } else {
        LocalData.saveInt(DatabaseKeys().HIGH_SCORE, gameRef.gameScore);
        saveHighScoreOnServer(gameRef.gameScore);
      }
    }
  }
}

void saveHighScoreOnServer(int score) {
  var docId = LocalData.getString(DatabaseKeys().userID);
  FirebaseFirestore.instance
      .collection("Users")
      .doc(docId)
      .update({"high_score": score});
}
