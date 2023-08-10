import 'dart:io';


class AdsHelper {
  

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6966853236033666/6211559941';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6966853236033666/9358212436';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

    static String get intersetialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6966853236033666/9030646048';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6966853236033666~5519039771';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6966853236033666/2816854811';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6966853236033666/1503773146';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
