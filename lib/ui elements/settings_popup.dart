import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({super.key});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), side: const BorderSide()),
      backgroundColor: GameColors.thirdColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "Settings",
                style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                        fontSize: 25,
                        color: GameColors.blackColor,
                        fontWeight: FontWeight.w600)),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.clear_rounded))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: GameColors.forthColor),
            child: Column(children: [
              Row(
                children: [
                  const Icon(Icons.volume_up_rounded),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Music",
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: GameColors.blackColor)),
                  ),
                  const Spacer(),
                  Switch(
                    value: getIsMusicOn(),
                    onChanged: (d) {
                      setState(() {
                        LocalData.saveBool(DatabaseKeys().MUSIC, d);
                      });
                    },
                    activeColor: GameColors.firstColor,
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.volume_up_rounded),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Sound",
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: GameColors.blackColor)),
                  ),
                  const Spacer(),
                  Switch(
                    value: getIsSoundOn(),
                    onChanged: (d) {
                      setState(() {
                        LocalData.saveBool(DatabaseKeys().SOUND, d);
                      });
                    },
                    activeColor: GameColors.firstColor,
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  launchUrl(Uri.parse(
                      "https://techstrum.com/terms-and-conditions/index.html"));
                },
                child: Row(
                  children: [
                    const Icon(Icons.edit_document),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Terms of Service",
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: GameColors.blackColor)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  launchUrl(Uri.parse(
                      "https://techstrum.com/privacy-policy/index.html"));
                },
                child: Row(
                  children: [
                    const Icon(Icons.privacy_tip_rounded),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Privacy Policy",
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: GameColors.blackColor)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "${packageInfo.version}(${packageInfo.buildNumber})",
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 14,
                      color: GameColors.blackColor,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "MADE BY: TECHSTRUM",
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 16,
                      color: GameColors.blackColor,
                      fontWeight: FontWeight.w500)),
            )
          ])
        ],
      ),
    );
  }

  bool getIsSoundOn() {
    var isOn = true;
    if (LocalData.contains(DatabaseKeys().SOUND)) {
      isOn = LocalData.getBool(DatabaseKeys().SOUND);
    }
    return isOn;
  }

  bool getIsMusicOn() {
    var isOn = true;
    if (LocalData.contains(DatabaseKeys().MUSIC)) {
      isOn = LocalData.getBool(DatabaseKeys().MUSIC);
    }
    return isOn;
  }
}
