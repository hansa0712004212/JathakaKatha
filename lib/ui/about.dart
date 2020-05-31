import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:jathakakatha/data/constants.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: GlobalConfiguration().getString("AboutScreenFull"),
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: constAdsAboutScreen);
      },
    );

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
