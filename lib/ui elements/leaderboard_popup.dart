import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/constants/globals.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardPopup extends StatefulWidget {
  const LeaderboardPopup({super.key});

  @override
  State<LeaderboardPopup> createState() => _LeaderboardPopupState();
}

class _LeaderboardPopupState extends State<LeaderboardPopup> {
  TextEditingController usernameController = TextEditingController();
  List<Widget> widgetList = [];
  @override
  void initState() {
    getLederboardItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), side: const BorderSide()),
        backgroundColor: GameColors.thirdColor,
        titlePadding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        title: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "Leaderboard",
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
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      "assets/images/${Globals.cross_icon}",
                      height: 40,
                      width: 40,
                    ),
                  )),
            ),
          ],
        ),
        children: widgetList.isEmpty
            ? [
                const LinearProgressIndicator(
                  backgroundColor: GameColors.cyanColor,
                )
              ]
            : widgetList);
  }

  void getLederboardItems() {
    var db = FirebaseFirestore.instance;
    final usersRef = db
        .collection("Users")
        .orderBy("high_score", descending: true)
        .limit(100);
    usersRef.get().then((value) {
      for (var element in value.docs) {
        setState(() {
          widgetList.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                Text(
                  getUsername(element),
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: GameColors.greyColor)),
                ),
                const Spacer(),
                Text(
                  element.data()['high_score'].toString(),
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: GameColors.greyColor)),
                ),
              ],
            ),
          ));
        });
      }
    });
  }

  String getUsername(QueryDocumentSnapshot<Map<String, dynamic>> element) {
    if (element.id == LocalData.getString(DatabaseKeys().userID)) {
      return "You";
    } else {
      if (element.data()['userName'] == "NA") {
        return element.id.substring(0, 7);
      } else {
        return element.data()['userName'];
      }
    }
  }
}
