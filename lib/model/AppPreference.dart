import 'package:jathakakatha/data/sinhala.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  bool _isFirstTimeRun;
  double _storyFontSize;
  double _ttsSpeed;
  static SharedPreferences sharedPreferences;

  AppPreference._();

  bool get isFirstTimeRun =>
      sharedPreferences.getBool("isFirstTimeRun") ?? true;

  double get storyFontSize => _storyFontSize;

  set storyFontSize(double value) {
    _storyFontSize = value;
  }

  double get ttsSpeed => _ttsSpeed;

  set ttsSpeed(double value) {
    _ttsSpeed = value;
  }

  static Future<AppPreference> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool("isFirstTimeRun") ?? true) {
      sharedPreferences.setBool("isFirstTimeRun", false);
      sharedPreferences.setDouble("fontSizeStory", constFontSizeStory);
      sharedPreferences.setDouble("ttsSpeed", 1.0);
    }
    AppPreference preference = new AppPreference._();
    preference.storyFontSize =
        sharedPreferences.getDouble("fontSizeStory") ?? constFontSizeStory;
    preference.ttsSpeed = sharedPreferences.getDouble("ttsSpeed") ?? 1.0;
    return preference;
  }

  flushAppPreferences() async {
    sharedPreferences.setDouble("fontSizeStory", storyFontSize);
    sharedPreferences.setDouble("ttsSpeed", ttsSpeed);
  }
}
