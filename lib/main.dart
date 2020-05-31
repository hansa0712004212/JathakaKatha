import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:jathakakatha/ui/home.dart';
import 'package:jathakakatha/ui/welcome.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("ad_keys");
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'IskoolaPota'),
    home: Welcome(),
    routes: <String, WidgetBuilder>{
      '/Home': (BuildContext context) => Home(),
    },
  ));
}
