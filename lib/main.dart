import 'package:catch_the_balloons/ads/ads_provider.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/main_utils.dart';
import 'package:catch_the_balloons/screens/main_menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

late PackageInfo packageInfo;
// import 'package:hive_flutter/adapters.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ["85667F80-69FF-4839-8B62-BDBC0D4CAAF1"]));
  await Hive.initFlutter();
  FlameAudio.bgm.initialize();
  await Hive.openBox('DefaultDB');
  await FlameAudio.audioCache.loadAll([
    'background-music.mp3',
    'catch-balloon.mp3',
    'game-over.mp3',
    'catch-missed.mp3'
  ]);

  if (LocalData.contains(DatabaseKeys().DEVICE_TOKEN)) {
    var token = LocalData.getString(DatabaseKeys().DEVICE_TOKEN);
    if (kDebugMode) {
      print("token is $token");
    }

    await createNewUserOnServer(token);

    //CONTAINS
  } else {
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token) async {
      if (kDebugMode) {
        print("token is $token");
      }
      LocalData.saveString(DatabaseKeys().DEVICE_TOKEN, token!);
      await createNewUserOnServer(token);
    });
  }
  packageInfo = await PackageInfo.fromPlatform();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AdsProvider()),
    ],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenuScreen(),
    ),
  ));
}

Future<void> createNewUserOnServer(String token) async {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  analytics.logEvent(name: "New User Registered");

  var userCollection = FirebaseFirestore.instance.collection("Users");

  if (LocalData.contains(DatabaseKeys().userID)) {
    var userId = LocalData.getString(DatabaseKeys().userID);
    userCollection.doc(userId).update({
      "deviceToken": token,
      "high_score": getHighestScore(),
      "userName": MainUtils().getUsername(),
    }).then((value) {
      LocalData.saveString(DatabaseKeys().userID, userId);
    });
  } else {
    userCollection.add({
      "deviceToken": token,
      "userName": "NA",
      "timestamp": DateTime.now(),
      "high_score": getHighestScore(),
    }).then((value) {
      LocalData.saveString(DatabaseKeys().userID, value.id);
    });
  }
}

int getHighestScore() {
  if (LocalData.contains(DatabaseKeys().HIGH_SCORE)) {
    return LocalData.getInt(DatabaseKeys().HIGH_SCORE);
  } else {
    return 0;
  }
}
