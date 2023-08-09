import 'dart:ui';

import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/globals.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/${Globals.backgroundSprite}"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: SizedBox(
            width: double.maxFinite,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "CATCH THE",
                style: GoogleFonts.shojumaru(
                  textStyle: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: GameColors.firstColor),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "BALLOONS",
                style: GoogleFonts.shojumaru(
                  textStyle: const TextStyle(
                      fontSize: 40,
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
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const GameScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border:
                          Border.all(color: GameColors.greyColor, width: 4)),
                  child: Text(
                    "PLAY",
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: GameColors.greyColor)),
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
