import 'package:flutter/material.dart';
import 'package:flutter_icomoon_icons/flutter_icomoon_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:jathakakatha/data/sinhala.dart';
import 'package:jathakakatha/model/Tale.dart';

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
                                onPressed: () => playTTS(widget.tale.story),
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
                          onPressed: () => print("share button pressed"),
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
      });

      await flutterTts.setLanguage(constTtsLanguage);
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.setPitch(1.2);
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
    }
  }

  Future playTTS(String text) async {
    if (flutterTts != null) {
      if (isSpeaking) {
        setState(() {
          isSpeaking = false;
        });
        flutterTts.stop();
      } else {
        setState(() {
          isSpeaking = true;
        });

        if (text.length <= constTtsMaxLength) {
          await flutterTts.speak(text);
        } else {
          var parts = (text.length / constTtsMaxLength);
          flutterTts.speak(text.substring(0, constTtsMaxLength));
          setState(() {
            currentTtsPart = 1;
          });
        }
      }
    }
  }
}
