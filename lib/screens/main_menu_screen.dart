import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:catch_the_balloons/ads/ads_helper.dart';
import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/main_utils.dart';
import 'package:catch_the_balloons/screens/game_screen.dart';
import 'package:catch_the_balloons/ui%20elements/leaderboard_popup.dart';
import 'package:catch_the_balloons/ui%20elements/settings_popup.dart';
import 'package:catch_the_balloons/ui%20elements/username_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants/globals.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

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
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/${Globals.user_icon}",
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    MainUtils().getUsername(),
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: GameColors.blackColor),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      //USERNAME CHANGE POPUP
                                      showUsernamePopup(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Image.asset(
                                        "assets/images/${Globals.edit_icon}",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  //SETTINGS POPUP
                                  showMySettingPopup(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.asset(
                                    "assets/images/${Globals.setting_icon}",
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showLeaderboardPopup(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Image.asset(
                              "assets/images/${Globals.leaderboard_icon}",
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            "CATCH THE",
                            maxLines: 1,
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
                                  color: GameColors.firstColor),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          AutoSizeText(
                            "BALLOONS",
                            maxLines: 1,
                            maxFontSize: 40,
                            style: GoogleFonts.shojumaru(
                              textStyle: const TextStyle(
                                  shadows: [
                                    Shadow(
                                        blurRadius: 3,
                                        offset: Offset(3, 4),
                                        color: GameColors.greyColor),
                                  ],
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
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const GameScreen(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                      color: GameColors.greyColor, width: 4)),
                              child: Text(
                                "PLAY",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: GameColors.greyColor)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible:
                                LocalData.contains(DatabaseKeys().HIGH_SCORE),
                            child: Text(
                              "HIGHEST SCORE: ${getHighestScore()}",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: GameColors.blackColor),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
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
      ),
    );
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

  int getHighestScore() {
    if (LocalData.contains(DatabaseKeys().HIGH_SCORE)) {
      return LocalData.getInt(DatabaseKeys().HIGH_SCORE);
    } else {
      return 0;
    }
  }

  Future<void> showUsernamePopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return UsernamePopup(
          username: MainUtils().getUsername(),
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  Future<void> showLeaderboardPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const LeaderboardPopup();
      },
    );
  }

  Future<void> showMySettingPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const SettingsPopup();
      },
    );
  }
}
