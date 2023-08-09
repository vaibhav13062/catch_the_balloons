import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/screens/main_menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import 'package:hive_flutter/adapters.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('DefaultDB');
  if (LocalData.contains(DatabaseKeys().DEVICE_TOKEN)) {
    var token = LocalData.getString(DatabaseKeys().DEVICE_TOKEN);
    if (kDebugMode) {
      print("token is $token");
    }
    //CONTAINS
  } else {
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print("token is $token");
      }
      LocalData.saveString(DatabaseKeys().DEVICE_TOKEN, token!);
      createNewUserOnServer(token);
    });
  }

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainMenuScreen(),
  ));
}

void createNewUserOnServer(String token) {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  analytics.logEvent(name: "New User Registered");

  var userCollection = FirebaseFirestore.instance.collection("Users");

  userCollection.add({
    "deviceToken": token,
    "userName": token,
    "timestamp": DateTime.now()
  }).then((value) {
    LocalData.saveString(DatabaseKeys().userID, value.id);
  });
}