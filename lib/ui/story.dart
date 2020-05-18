import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_icomoon_icons/flutter_icomoon_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:jathakakatha/data/sinhala.dart';
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

  @override
  void initState() {
    super.initState();
    initializeTTS();
  }

  @override
  void dispose() {
    super.dispose();
    if (flutterTts != null) {
      flutterTts.stop();
      flutterTts = null;
      isSpeaking = false;
      currentTtsPart = 0;
      currentUtterIndex = 0;
      isPaused = false;
    }
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
                          style: TextStyle(fontSize: constFontSizeStory),
                          textAlign: TextAlign.justify)),
                ),
                fit: FlexFit.tight,
                flex: 1)
          ],
        ),
      ),
      onWillPop: () {
        navigationPage(context, "Home");
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
    Share.share("${widget.tale.title}\n\n${widget.tale.story}\n\n$constPansiyaPanas $constAppName\n\nhttps://play.google.com/store/apps/details?id=com.sahassoft.jathakakatha",
        subject: "${widget.tale.title}",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
