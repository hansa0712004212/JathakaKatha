import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_icomoon_icons/flutter_icomoon_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:jathakakatha/component/CustomSliderThumbCircle.dart';
import 'package:jathakakatha/data/sinhala.dart';
import 'package:jathakakatha/model/AppPreference.dart';
import 'package:jathakakatha/model/Tale.dart';
import 'package:share/share.dart';

class Story extends StatefulWidget {
  final Tale tale;

  Story({this.tale});

  @override
  _State createState() => _State();
}

class _State extends State<Story> {
  static FlutterTts flutterTts;
  static bool isSiLkPossible = false;
  static bool isSpeaking = false;
  static int currentTtsPart = 0;
  static int currentUtterIndex = 0;
  static bool isPaused = false;

  double _fontSizeStory = 20;
  double _ttsSpeed = 1;
  AppPreference appPreference;
  static bool _isBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    initializeTTS();
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
  void dispose() {
    if (flutterTts != null) {
      flutterTts.stop();
      flutterTts = null;
      isSpeaking = false;
      currentTtsPart = 0;
      currentUtterIndex = 0;
      isPaused = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeTTS();
    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                    tag: widget.tale.id,
                    child: Image(
                      image: AssetImage(widget.tale.image),
                      fit: BoxFit.cover,
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Material(
                        color: constColorTransparent,
                        child: IconButton(
                          icon: IconShadowWidget(
                              Icon(IcoMoonIcons.arrowLeft2,
                                  color: constColorIcon),
                              showShadow: true,
                              shadowColor: constColorIconShadow),
                          iconSize: constIconSize,
                          color: constColorIcon,
                          splashColor: constColorIconSplash,
                          onPressed: () => this.navigationPage(context, "Home"),
                        ),
                      ),
                      new Spacer(),
                      new Material(
                        color: constColorTransparent,
                        child: IconButton(
                          icon: IconShadowWidget(
                              Icon(IcoMoonIcons.cog, color: constColorIcon),
                              showShadow: true,
                              shadowColor: constColorIconShadow),
                          color: constColorIcon,
                          splashColor: constColorIconSplash,
                          onPressed: () => setState(() {
                            _isBottomSheetVisible = !_isBottomSheetVisible;
                          }),
                        ),
                      ),
                      isSiLkPossible && isSpeaking
                          ? new Material(
                              color: constColorTransparent,
                              child: IconButton(
                                icon: IconShadowWidget(
                                    Icon(
                                        isPaused
                                            ? IcoMoonIcons.play3
                                            : IcoMoonIcons.pause2,
                                        color: constColorIcon),
                                    showShadow: true,
                                    shadowColor: constColorIconShadow),
                                color: constColorIcon,
                                splashColor: constColorIconSplash,
                                onPressed: () => pauseTTS(),
                              ),
                            )
                          : Container(height: 0),
                      isSiLkPossible
                          ? new Material(
                              color: constColorTransparent,
                              child: IconButton(
                                icon: IconShadowWidget(
                                    isSpeaking
                                        ? Icon(IcoMoonIcons.stop2,
                                            color: constColorIcon)
                                        : Icon(IcoMoonIcons.play3,
                                            color: constColorIcon),
                                    showShadow: true,
                                    shadowColor: constColorIconShadow),
                                color: constColorIcon,
                                splashColor: constColorIconSplash,
                                onPressed: () =>
                                    isSpeaking ? stopTTS() : playTTS(),
                              ),
                            )
                          : Container(height: 0),
                      new Material(
                        color: constColorTransparent,
                        child: IconButton(
                          icon: IconShadowWidget(
                              Icon(IcoMoonIcons.share2, color: constColorIcon),
                              showShadow: true,
                              shadowColor: constColorIconShadow),
                          color: constColorIcon,
                          splashColor: constColorIconSplash,
                          onPressed: () => shareStory(),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(constPaddingSpace, 180, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Flexible(
                            child: Text(
                              "${widget.tale.id}. ${widget.tale.title}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: constColorDefaultText,
                                  fontSize: constFontSizeTileIndex,
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 2.5),
                                      blurRadius: 1.5,
                                      color: constColorIconShadow,
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(constPaddingSpace,
                      constPaddingSpace, constPaddingSpace, constPaddingSpace),
                  child: SingleChildScrollView(
                      child: Text("${widget.tale.story}\n",
                          style: TextStyle(fontSize: _fontSizeStory),
                          textAlign: TextAlign.justify)),
                ),
                fit: FlexFit.tight,
                flex: 1)
          ],
        ),
        bottomSheet: _isBottomSheetVisible
            ? BottomSheet(
                onClosing: () {},
                builder: (context) => _getBottomSheet(),
              )
            : null,
      ),
      onWillPop: () async {
        navigationPage(context, "Home");
        return true;
      },
    );
  }

  void navigationPage(defaultContext, screenName) {
    Navigator.of(defaultContext).pushReplacementNamed('/$screenName');
  }

  Future initializeTTS() async {
    if (flutterTts == null) {
      flutterTts = new FlutterTts();
      bool isLanguageAvailable =
          await flutterTts.isLanguageAvailable(constTtsLanguage);
      setState(() {
        isSiLkPossible = isLanguageAvailable;
        currentUtterIndex = 0;
        currentTtsPart = 0;
      });

      await flutterTts.setLanguage(constTtsLanguage);
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.setPitch(1.2);
      flutterTts.setStartHandler(() {
        setState(() {
          isSpeaking = true;
        });
      });
      flutterTts.setProgressHandler(
          (String text, int startOffset, int endOffset, String word) {
        setState(() {
          currentUtterIndex =
              ((currentTtsPart - 1) * constTtsMaxLength) + startOffset;
        });
      });
      flutterTts.setCompletionHandler(() {
        if (widget.tale.story.length <= constTtsMaxLength) {
          setState(() {
            isSpeaking = false;
          });
        } else {
          int nextTargetIndex = 0;
          int storyLength = widget.tale.story.length;
          int noOfPartsPossible = (storyLength / constTtsMaxLength).ceil();
          if (noOfPartsPossible == currentTtsPart + 1) {
            nextTargetIndex = widget.tale.story.length;
          } else if (noOfPartsPossible < currentTtsPart + 1) {
            setState(() {
              isSpeaking = false;
            });
            return;
          } else {
            nextTargetIndex =
                (constTtsMaxLength * currentTtsPart) + constTtsMaxLength;
          }

          flutterTts.speak(widget.tale.story.substring(
              (constTtsMaxLength * currentTtsPart), nextTargetIndex));
          setState(() {
            currentTtsPart = currentTtsPart + 1;
          });
        }
      });
      flutterTts.setErrorHandler((msg) {
        setState(() {
          isSpeaking = false;
          currentTtsPart = 0;
          isPaused = false;
          currentUtterIndex = 0;
        });
      });
    }
  }

  Future playTTS() async {
    if (flutterTts != null) {
      if (isPaused) {
        setState(() {
          isPaused = false;
          isSpeaking = true;
        });
        try {
          if ((widget.tale.story.length / constTtsMaxLength).ceil() ==
              (currentTtsPart / 1.0)) {
            await flutterTts
                .speak(widget.tale.story.substring(currentUtterIndex));
          } else {
            await flutterTts.speak(widget.tale.story.substring(
                currentUtterIndex, (currentTtsPart) * constTtsMaxLength));
          }
        } catch (e) {
          await stopTTS();
        }
      } else {
        if (widget.tale.story.length <= constTtsMaxLength) {
          await flutterTts.speak(widget.tale.story);
        } else {
          flutterTts.speak(widget.tale.story.substring(0, constTtsMaxLength));
          setState(() {
            currentTtsPart = 1;
          });
        }
      }
    }
  }

  Future pauseTTS() async {
    if (isPaused) {
      await playTTS();
    } else {
      setState(() {
        isPaused = true;
      });
      if (Platform.isIOS) {
        flutterTts.pause();
      } else {
        flutterTts.stop();
      }
    }
  }

  Future stopTTS() async {
    if (flutterTts != null) {
      flutterTts.stop();
    }
    setState(() {
      isPaused = false;
      isSpeaking = false;
      currentTtsPart = 0;
      currentUtterIndex = 0;
    });
  }

  Future shareStory() async {
    final RenderBox box = context.findRenderObject();
    Share.share(
        "${widget.tale.title}\n\n${widget.tale.story}\n\n$constPansiyaPanas $constAppName\n\nhttps://play.google.com/store/apps/details?id=com.sahassoft.jathakakatha",
        subject: "${widget.tale.title}",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _displayBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
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
                  width: 100,
                  height: 30,
                  child: Text("කථන වේගය ",
                      style: TextStyle(fontSize: constFontSizeBody)),
                ),
                Text("")
              ],
            )
          ],
        );
      },
    );
  }

  void _resetPreferences() {
    setState(() {
      _fontSizeStory = appPreference.storyFontSize;
      _ttsSpeed = appPreference.ttsSpeed;
    });
  }
  
  void _cancelPreferences() {
    _resetPreferences();
    setState(() {
      _isBottomSheetVisible = false;
    });
  }

  void _flushPreferences() {
    appPreference.storyFontSize = _fontSizeStory;
    appPreference.ttsSpeed = _ttsSpeed;
    setState(() {
      _isBottomSheetVisible = false;
    });
    appPreference.flushAppPreferences();
  }

  Widget _getBottomSheet() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(constBorderRadius)),
          color: constColorPrimary.withAlpha(140)),
      child: Padding(
        padding: EdgeInsets.all(constPaddingSpace),
        child: ListView(
          children: <Widget>[
            Column(
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
                          activeTrackColor: constColorDefaultText,
                          inactiveTrackColor: constColorDefaultDisabled,
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 2.0,
                          thumbColor: constColorPrimary,
                          thumbShape:
                              CustomSliderThumbCircle(thumbRadius: 16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 35,
                      child: Text(
                        "කථන වේගය",
                        style: TextStyle(
                          fontSize: constFontSizeBody,
                        ),
                      ),
                    ),
                    SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: constColorDefaultText,
                          inactiveTrackColor: constColorDefaultDisabled,
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 2.0,
                          thumbColor: constColorPrimary,
                          thumbShape:
                              CustomSliderThumbCircle(thumbRadius: 16.0),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ButtonBar(children: <Widget>[
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text("යළි පිහිටුවන්න"),
                        onPressed: () => this._resetPreferences(),
                      ),
                      OutlineButton(
                        textColor: Colors.orange,
                        child: Text("අවලංගු කරන්න"),
                        onPressed: () => this._cancelPreferences(),
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text("තහවුරු කරන්න"),
                        onPressed: () => this._flushPreferences(),
                      ),
                    ], alignment: MainAxisAlignment.spaceBetween)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
