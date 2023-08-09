import 'dart:ui';

import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/game/MainGame.dart';
import 'package:catch_the_balloons/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverScreen extends StatelessWidget {
  static const String ID = "GameOverScreen";
  final MainGame gameRef;
  const GameOverScreen({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: GameColors.blackColor.withOpacity(0.05),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "FINAL SCORE: ${gameRef.gameScore}",
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: GameColors.blackColor),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "GAME OVER",
                style: GoogleFonts.shojumaru(
                  textStyle: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: GameColors.secondColor),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  gameRef.overlays.remove(GameOverScreen.ID);
                  gameRef.reset();
                  gameRef.resumeEngine();

                  // Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //   return const GameScreen();
                  // }));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border:
                          Border.all(color: GameColors.greyColor, width: 4)),
                  child: Text(
                    "PLAY AGAIN!",
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: GameColors.greyColor)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  gameRef.overlays.remove(GameOverScreen.ID);
                  gameRef.reset();
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const MainMenuScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    "Go to Home Screen",
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: GameColors.blackColor)),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
