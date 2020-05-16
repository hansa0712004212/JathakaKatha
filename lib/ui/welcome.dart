import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Welcome extends StatelessWidget {
  BuildContext defaultContext;

  @override
  Widget build(BuildContext context) {
    defaultContext = context;
    _portraitModeOnly();
    startTime() async {
      var _duration = new Duration(seconds: 2);
      return new Timer(_duration, navigationPage);
    }

    startTime();
    return Material(
        color: Colors.amber,
        shadowColor: Colors.deepOrange,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/lord-buddha.jpg"),
                    fit: BoxFit.cover)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "550",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 64 ,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 3),
                            blurRadius: 4.0,
                            color: Color.fromARGB(255, 255, 191, 0),
                          )
                        ]),
                  ),
                  Text(
                    "ජාතක කතා",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 54,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 3),
                            blurRadius: 4.0,
                            color: Color.fromARGB(230, 255, 0, 127),
                          )
                        ]),
                  ),
                  Text(
                    "",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 3),
                            blurRadius: 4.0,
                            color: Color.fromARGB(230, 255, 0, 127),
                          )
                        ]),
                  )
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

  void navigationPage() {
    // to navigate
  }
}