import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jathakakatha/data/sinhala.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final int _duration = 2;

  @override
  void initState() {
    super.initState();
    _startTime();
    _portraitModeOnly();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: constColorPrimary,
        shadowColor: constColorSecondary,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: constWelcomeBackgroundImage, fit: BoxFit.cover)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "$constPansiyaPanas",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 64,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 3),
                            blurRadius: 4.0,
                            color: constColorSplashNumberTitle,
                          )
                        ]),
                  ),
                  Text(
                    "$constAppName",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 54,
                        color: constColorDefaultText,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 3),
                            blurRadius: 4.0,
                            color: constColorSplashTextTitle,
                          )
                        ]),
                  ),
                  Text(
                    "",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: constColorDefaultText,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 3),
                            blurRadius: 4.0,
                            color: constColorSplashTextTitle,
                          )
                        ]),
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      verticalDirection: VerticalDirection.up,
                      children: _initProgressBars())
                ])));
  }

// blocks rotation; sets orientation to: portrait
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

// reset rotation to system preferred
  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  _startTime() async {
    var duration = new Duration(seconds: _duration);
    return new Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacementNamed(context, "/Home");
    _enableRotation();
  }

  List<Flexible> _initProgressBars() {
    List<Color> progressBarColors = [
      Color.fromARGB(255, 0, 0, 255),
      Colors.yellow,
      Colors.red,
      Colors.white,
      Colors.orange
    ];

    List<Flexible> flexibleProgressBars = [];
    progressBarColors.asMap().forEach((key, value) {
      flexibleProgressBars.add(Flexible(
        child: new LinearPercentIndicator(
            percent: 1,
            animation: true,
            animationDuration: _duration * 800,
            progressColor: progressBarColors.elementAt(key),
            padding: EdgeInsets.fromLTRB(
                0, 0, key == progressBarColors.length - 1 ? 0 : 5, 0),
            backgroundColor: progressBarColors.elementAt(key).withAlpha(100)),
      ));
    });
    return flexibleProgressBars;
  }
}
