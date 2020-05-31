import 'package:flutter/material.dart';
import 'package:jathakakatha/data/constants.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constColorPrimary,
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 1.0,
        backgroundColor: constColorPrimary,
        title: Text(
          "$constAbout",
          textDirection: TextDirection.ltr,
          style: TextStyle(
              fontSize: constFontSizeTitle, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [constColorPrimary, constColorDefaultText],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 1])),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: constPaddingSpace, vertical: constPaddingSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[],
            ),
          )),
    );
  }
}
