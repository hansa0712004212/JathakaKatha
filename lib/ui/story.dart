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
  static bool isPaused = false;
  static int _currentSentenceIndex = 0;
  List<String> _splitStoryList = [];

  double _fontSizeStory = 20;
  double _ttsSpeed = 1;
  String _ttsSpeedKey;
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
      _ttsSpeedKey = _getTtsSpeedMap(appPreference.ttsSpeed);
    });
    _updateRecentList();
  }

  String _getTtsSpeedMap(double speed) {
    int checkable = (speed * 10).toInt();
    switch (checkable) {
      case 6:
        return fontSizeMap.keys.toList()[0];
      case 8:
        return fontSizeMap.keys.toList()[1];
      case 10:
        return fontSizeMap.keys.toList()[2];
      case 12:
        return fontSizeMap.keys.toList()[3];
      case 14:
        return fontSizeMap.keys.toList()[4];
      default:
        return fontSizeMap.keys.toList()[2];
    }
  }

  @override
  void dispose() {
    if (flutterTts != null) {
      flutterTts.stop();
    }
    flutterTts = null;
    isSpeaking = false;
    isPaused = false;
    _isBottomSheetVisible = false;
    _currentSentenceIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 26),
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
                  padding: EdgeInsets.fromLTRB(0, 170, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (widget.tale.id != 1)
                              ? new Material(
                                  color: constColorTransparent,
                                  child: IconButton(
                                      icon: IconShadowWidget(
                                          Icon(IcoMoonIcons.previous2,
                                              color: constColorIcon),
                                          showShadow: true,
                                          shadowColor: constColorIconShadow),
                                      color: constColorIcon,
                                      splashColor: constColorIconSplash,
                                      onPressed: _previousStory),
                                )
                              : Container(height: 0),
                          new Flexible(
                            child: Text(
                              "${widget.tale.id}. ${widget.tale.title}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: constColorDefaultText,
                                  fontSize: constFontSizeTileIndex,
                                  fontWeight: FontWeight.bold,
                                  shadows: constDefaultTextShadow),
                            ),
                          ),
                          (widget.tale.id != tales.length)
                              ? new Material(
                                  color: constColorTransparent,
                                  child: IconButton(
                                      icon: IconShadowWidget(
                                          Icon(IcoMoonIcons.next2,
                                              color: constColorIcon),
                                          showShadow: true,
                                          shadowColor: constColorIconShadow),
                                      color: constColorIcon,
                                      splashColor: constColorIconSplash,
                                      onPressed: _nextStory),
                                )
                              : Container(height: 0),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            constColorPrimary.withAlpha(200),
                            constColorDefaultText
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0001, 0.03])),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        constPaddingSpace,
                        constPaddingSpace,
                        constPaddingSpace,
                        constPaddingSpace),
                    child: SingleChildScrollView(
                        child: Text("${widget.tale.story}\n",
                            style: TextStyle(fontSize: _fontSizeStory),
                            textAlign: TextAlign.justify)),
                  ),
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

  Future _splitStory() async {
    _splitStoryList = widget.tale.story.split(".");
  }

  Future initializeTTS() async {
    if (flutterTts == null) {
      flutterTts = new FlutterTts();
      bool isLanguageAvailable =
          await flutterTts.isLanguageAvailable(constTtsLanguage);
      if (isLanguageAvailable) {
        setState(() {
          isSiLkPossible = isLanguageAvailable;
          _currentSentenceIndex = 0;
        });
        await _splitStory();
        await flutterTts.setLanguage(constTtsLanguage);
        await flutterTts.setSpeechRate(_ttsSpeed);
        await flutterTts.setPitch(1.2);

        flutterTts.setStartHandler(() {
          setState(() {
            isSpeaking = true;
          });
        });
        flutterTts.setCompletionHandler(() async {
          int _currentSentenceIndexTemp = ++_currentSentenceIndex;
          setState(() {
            _currentSentenceIndex = _currentSentenceIndexTemp;
          });
          if (_currentSentenceIndexTemp != _splitStoryList.length) {
            await playTTS();
          } else {
            await stopTTS();
          }
        });
        flutterTts.setErrorHandler((msg) async {
          await stopTTS();
        });
      }
    }
  }

  Future playTTS() async {
    await flutterTts.speak(_splitStoryList[_currentSentenceIndex]);
    setState(() {
      isSpeaking = true;
      isPaused = false;
    });
  }

  Future pauseTTS() async {
    if (isPaused) {
      await playTTS();
    } else {
      await flutterTts.stop();
      setState(() {
        isPaused = true;
      });
    }
  }

  Future stopTTS() async {
    await flutterTts.stop();
    setState(() {
      isPaused = false;
      isSpeaking = false;
      _currentSentenceIndex = 0;
    });
  }

  Future shareStory() async {
    final RenderBox box = context.findRenderObject();
    Share.share(
        "${widget.tale.title}\n\n${widget.tale.story}\n\n$constPansiyaPanas $constAppName\n\nhttps://play.google.com/store/apps/details?id=com.sahassoft.jathakakatha",
        subject: "${widget.tale.title}",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
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
    flutterTts.setSpeechRate(_ttsSpeed);
    appPreference.flushAppPreferences();
  }

  void _updateRecentList() {
    appPreference.updateRecent(widget.tale.id);
    appPreference.flushAppPreferences();
  }

  Widget _getBottomSheet() {
    return Container(
      height: isSpeaking ? 132 : 180,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(constBorderRadius)),
          color: Colors.grey.withAlpha(40)),
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
                          activeTrackColor: constColorPrimary,
                          inactiveTrackColor: constColorDefaultDisabled,
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 1.5,
                          thumbColor: constColorDefaultText,
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
                !isSpeaking
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 130,
                            height: 35,
                            child: Text(
                              "කථන වේගය",
                              style: TextStyle(
                                fontSize: constFontSizeBody,
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            value: _ttsSpeedKey,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: constColorPrimary),
                            underline: Container(
                              height: 2,
                              color: constColorPrimary,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                _ttsSpeedKey = newValue;
                                _ttsSpeed = fontSizeMap[newValue];
                              });
                            },
                            items: fontSizeMap.keys
                                .toList()
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ButtonBar(children: <Widget>[
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text("යළි පිහිටුවන්න"),
                        onPressed: () => this._resetPreferences(),
                      ),
                      RaisedButton(
                        color: Colors.orangeAccent,
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

  void _nextStory() {
    dispose();
    Tale nextStory = tales.elementAt(widget.tale.id);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => Story(tale: nextStory)));
  }

  void _previousStory() {
    dispose();
    Tale previousStory = tales.elementAt(widget.tale.id - 2);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => Story(tale: previousStory)));
  }
}
