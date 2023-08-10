import 'dart:ui';

import 'package:catch_the_balloons/ads/ads_helper.dart';
import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/screens/game_screen.dart';
import 'package:catch_the_balloons/ui%20elements/settings_popup.dart';
import 'package:flame_audio/flame_audio.dart';
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          //SETTINGS POPUP
                          showMySettingPopup(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  color: GameColors.blackColor, width: 4)),
                          child: const Icon(Icons.settings),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const Spacer(
                    flex: 8,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                  const Spacer(
                    flex: 10,
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
    return LocalData.getInt(DatabaseKeys().HIGH_SCORE);
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
