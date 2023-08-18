import 'package:catch_the_balloons/constants/colors.dart';
import 'package:catch_the_balloons/database/database_keys.dart';
import 'package:catch_the_balloons/database/local_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainUtils {
  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: GameColors.cyanColor,
        textColor: GameColors.blackColor,
        fontSize: 16.0);
  }

  String getUsername() {
    if (LocalData.contains(DatabaseKeys().USERNAME)) {
      return LocalData.getString(DatabaseKeys().USERNAME);
    } else {
      if (LocalData.contains(DatabaseKeys().userID)) {
        return LocalData.getString(DatabaseKeys().userID).substring(0, 7);
      } else {
        return "NA";
      }
    }
  }
}
