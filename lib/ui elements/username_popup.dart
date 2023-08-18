import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/constants/globals.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:catch_the_balloons/main_utils.dart';
import 'package:catch_the_balloons/ui%20elements/small_sized_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsernamePopup extends StatefulWidget {
  final String username;
  const UsernamePopup({super.key, required this.username});

  @override
  State<UsernamePopup> createState() => _UsernamePopupState();
}

class _UsernamePopupState extends State<UsernamePopup> {
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    usernameController.text = widget.username;
    super.initState();
  }

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
                "Username",
                style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: GameColors.blackColor,
                        fontWeight: FontWeight.w600)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        "assets/images/" + Globals.cross_icon,
                        height: 40,
                        width: 40,
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: GameColors.cyanColor),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(border: InputBorder.none),
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 16,
                      color: GameColors.blackColor,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SmallSizedButton(
            text: "Save",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            function: () {
              if (usernameController.text.isEmpty) {
                MainUtils().showToast("Username can't be empty");
                return;
              } else if (usernameController.text.length < 5) {
                MainUtils().showToast("Username should be >= 5");
                return;
              }

              LocalData.saveString(
                  DatabaseKeys().USERNAME, usernameController.text);

              var docId = LocalData.getString(DatabaseKeys().userID);
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(docId)
                  .update({"userName": usernameController.text});

              Navigator.of(context).pop();
            },
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            color: GameColors.cyanColor,
          ),
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
