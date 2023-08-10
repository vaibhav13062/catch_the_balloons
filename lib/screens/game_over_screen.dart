import 'dart:ui';

import 'package:catch_the_balloons/ads/ads_helper.dart';
import 'package:catch_the_balloons/ads/ads_provider.dart';
import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/game/main_game.dart';
import 'package:catch_the_balloons/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class GameOverScreen extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String ID = "GameOverScreen";
  final MainGame gameRef;
  const GameOverScreen({super.key, required this.gameRef});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  bool showHomeScreenButton = false;
  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showHomeScreenButton = true;
      });
    });
  }

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
            child: Column(
              children: [
                Spacer(),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Visibility(
                    visible: LocalData.contains(DatabaseKeys().HIGH_SCORE),
                    child: Text(
                      "HIGHEST SCORE: ${getHighestScore()}",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: GameColors.blackColor),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "YOUR SCORE: ${widget.gameRef.gameScore}",
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
                  Visibility(
                    visible: Provider.of<AdsProvider>(context, listen: false)
                            .rewardedAd !=
                        null,
                    child: InkWell(
                      onTap: () {
                        Provider.of<AdsProvider>(context, listen: false)
                            .rewardedAd
                            ?.show(onUserEarnedReward:
                                (AdWithoutView ad, RewardItem rewardItem) {
                          widget.gameRef.overlays.remove(GameOverScreen.ID);
                          widget.gameRef.replay();
                          widget.gameRef.resumeEngine();
                          Provider.of<AdsProvider>(context, listen: false)
                              .rewardedAd
                              ?.dispose();
                          Provider.of<AdsProvider>(context, listen: false)
                              .loadRewaredAd();
                          print("REARD AWARDED");
                        });

                        // Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(builder: (BuildContext context) {
                        //   return const GameScreen();
                        // }));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                                color: GameColors.greyColor, width: 4)),
                        child: Text(
                          "CONTINUE",
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: GameColors.greyColor)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: showHomeScreenButton,
                    child: InkWell(
                      onTap: () async {

                          await  Provider.of<AdsProvider>(context,listen: false).interstitialAd?.show();

                        widget.gameRef.overlays.remove(GameOverScreen.ID);
                        widget.gameRef.reset();
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        child: Text(
                          "Go to Home Screen",
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: GameColors.blackColor)),
                        ),
                      ),
                    ),
                  )
                ]),
                Spacer(),
                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int getHighestScore() {
    return LocalData.getInt(DatabaseKeys().HIGH_SCORE);
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdsHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }
}
