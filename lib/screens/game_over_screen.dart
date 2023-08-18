// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:catch_the_balloons/ads/ads_helper.dart';
import 'package:catch_the_balloons/ads/ads_provider.dart';
import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/game/main_game.dart';
import 'package:catch_the_balloons/screens/main_menu_screen.dart';
import 'package:flutter/foundation.dart';
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
  bool _adWatched = false;

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
            child: Stack(
              alignment: Alignment.center,
              children: [
               
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    AutoSizeText(
                      "GAME OVER",
                      maxLines: 2,
                      maxFontSize: 50,
                      style: GoogleFonts.shojumaru(
                        textStyle: const TextStyle(
                           shadows: [
                                    Shadow(
                                        blurRadius: 3,
                                        offset: Offset(3, 4),
                                        color: GameColors.greyColor),
                                  ],
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            color: GameColors.secondColor),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      _adWatched ? "Reward Earned" : "Watch the Ad to Resume",
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: GameColors.greyColor)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: Provider.of<AdsProvider>(context, listen: false)
                              .rewardedAd !=
                          null,
                      child: InkWell(
                        onTap: () {
                          if (_adWatched) {
                            widget.gameRef.overlays.remove(GameOverScreen.ID);
                            widget.gameRef.replay();
                            setState(() {
                              _adWatched = false;
                            });
                          } else {
                            Provider.of<AdsProvider>(context, listen: false)
                                .rewardedAd
                                ?.show(onUserEarnedReward: (AdWithoutView ad,
                                    RewardItem rewardItem) async {
                              setState(() {
                                _adWatched = true;
                              });
                
                              await Provider.of<AdsProvider>(context,
                                      listen: false)
                                  .rewardedAd
                                  ?.dispose();
                              Provider.of<AdsProvider>(context, listen: false)
                                  .loadRewardedAd();
                              if (kDebugMode) {
                                print("REWARD AWARDED");
                              }
                            });
                          }
                
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
                            _adWatched ? "CONTINUE" : "WATCH AD",
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
                          await Provider.of<AdsProvider>(context, listen: false)
                              .interstitialAd
                              ?.show();
                          Provider.of<AdsProvider>(context, listen: false)
                              .interstitialAd
                              ?.dispose();
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
                ),
                
                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
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
    if (LocalData.contains(DatabaseKeys().HIGH_SCORE)) {
      return LocalData.getInt(DatabaseKeys().HIGH_SCORE);
    } else {
      return 0;
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdsHelper.bannerAdUnitId,
      request: const AdRequest(),
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

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
