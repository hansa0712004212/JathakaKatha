import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icomoon_icons/flutter_icomoon_icons.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:jathakakatha/component/CustomSliderThumbCircle.dart';
import 'package:jathakakatha/data/sinhala.dart';
import 'package:jathakakatha/model/AppPreference.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _fontSizeStory = 0;
  double _ttsSpeed = 1;
  AppPreference appPreference;

  @override
  initState() {
    super.initState();
    getSharedPreferences();
  }

  Future<Null> getSharedPreferences() async {
    appPreference = await AppPreference.getInstance();
    setState(() {
      _fontSizeStory = appPreference.storyFontSize;
      _ttsSpeed = appPreference.ttsSpeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "වරණ",
          style: TextStyle(
              fontSize: constFontSizeTitle, fontWeight: FontWeight.bold),
        ),
        backgroundColor: constColorPrimary,
        leading: IconButton(
          icon: IconShadowWidget(
            Icon(IcoMoonIcons.arrowLeft2,
                size: constIconSize, color: constColorDefaultText),
            showShadow: true,
            shadowColor: constColorDefaultText,
          ),
          onPressed: () => {this.navigationPage(context, "Home")},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(constPaddingSpace),
        child: ListView(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 35,
                  child: Text(
                    "අකුරු තරම",
                    style: TextStyle(
                      fontSize: constFontSizeBody,
                    ),
                  ),
                ),
                SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: constColorPrimary,
                      inactiveTrackColor: constColorDefaultDisabled,
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 2.0,
                      thumbColor: constColorDefaultText,
                      thumbShape: CustomSliderThumbCircle(thumbRadius: 16.0),
                      overlayColor: constColorPrimary.withAlpha(150),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 24.0),
                    ),
                    child: Slider.adaptive(
                      value: _fontSizeStory,
                      min: constFontSizeStoryMin,
                      max: constFontSizeStoryMax,
                      divisions: 4,
                      onChanged: (value) {
                        setState(() {
                          _fontSizeStory = value;
                        });
                      },
                    ))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Expanded(
                  child: Text(
                    "ජාතක අටුවාව සිංහලයට නගමින් ලියැවුණු මහා ධර්ම ශාස්ත්‍රීය, සාහිත්‍ය ග්‍රන්ථය නම් ‘පන්සිය පනස් ජාතක පොත’ යි. බුදුරජාණන් වහන්සේ විසින් දේශනා කරන ලද්දා වූ පූර්ව බෝසත් උත්පත්ති කථා වන බැවින් උත්පත්ති යන අර්ථයෙන් මේ කථා ‘ජාතක’ නම් වේ. මේ, සිංහල පන්සිය පනස් ජාතක පොත ලියැවී ඇත්තේ කුරුණෑගල සමයේ ය.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: _fontSizeStory),
                  ),
                ))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 20,
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 30,
                  child: Text("කථන වේගය ",
                      style: TextStyle(fontSize: constFontSizeBody)),
                ),
                Text("")
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigationPage(defaultContext, screenName) {
    Navigator.of(defaultContext).pushReplacementNamed('/$screenName');
  }
}
