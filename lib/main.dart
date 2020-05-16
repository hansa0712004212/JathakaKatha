import 'package:flutter/material.dart';
import 'package:jathakakatha/ui/home.dart';
import 'package:jathakakatha/ui/welcome.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'IskoolaPota'),
    home: Welcome(),
    routes: <String, WidgetBuilder>{
      '/Home': (BuildContext context) => Home(),
    },
  ));
}
