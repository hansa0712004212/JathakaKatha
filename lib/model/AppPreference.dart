import 'package:jathakakatha/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  bool isFirstTimeRun;
  double storyFontSize;
  double ttsSpeed;
  List<String> recentIds;
  static SharedPreferences sharedPreferences;

  AppPreference._();

  static Future<AppPreference> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool("isFirstTimeRun") ?? true) {
      sharedPreferences.setBool("isFirstTimeRun", false);
      sharedPreferences.setDouble("fontSizeStory", constFontSizeStory);
      sharedPreferences.setDouble("ttsSpeed", 1);
      sharedPreferences.setStringList("recentId", []);
    }
    AppPreference preference = new AppPreference._();
    preference.isFirstTimeRun = sharedPreferences.getBool("isFirstTimeRun");
    preference.storyFontSize = sharedPreferences.getDouble("fontSizeStory");
    preference.ttsSpeed = sharedPreferences.getDouble("ttsSpeed");
    preference.recentIds = sharedPreferences.getStringList("recentId");
    return preference;
  }

  flushAppPreferences() async {
    sharedPreferences.setDouble("fontSizeStory", storyFontSize);
    sharedPreferences.setDouble("ttsSpeed", ttsSpeed);
    sharedPreferences.setStringList("recentId", recentIds);
  }

  updateRecent(int newId) {
    if (recentIds.contains(newId.toString())) {
      recentIds.remove(newId.toString());
    }
    recentIds.add(newId.toString());
  }
}
