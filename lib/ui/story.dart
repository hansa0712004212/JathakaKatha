import 'package:flutter/material.dart';
import 'package:flutter_icomoon_icons/flutter_icomoon_icons.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:jathakakatha/model/Tale.dart';

class Story extends StatefulWidget {
  final Tale tale;

  Story({this.tale});

  @override
  _State createState() => _State();
}

class _State extends State<Story> {
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
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //change here don't //worked
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: IconShadowWidget(
                            Icon(IcoMoonIcons.arrowLeft2, color: Colors.white),
                            showShadow: true,
                            shadowColor: Colors.black),
                        iconSize: 20,
                        color: Colors.white,
                        onPressed: () => this.navigationPage(context, "Home"),
                      ),
                      new Spacer(),
                      IconButton(
                        icon: IconShadowWidget(
                            Icon(IcoMoonIcons.play3, color: Colors.white),
                            showShadow: true,
                            shadowColor: Colors.black),
                        color: Colors.white,
                        onPressed: () => print("volume button pressed"),
                      ),
                      IconButton(
                        icon: IconShadowWidget(
                            Icon(IcoMoonIcons.share2, color: Colors.white),
                            shadowColor: Colors.black),
                        color: Colors.white,
                        onPressed: () => print("share button pressed"),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 180, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${widget.tale.id}. ${widget.tale.title}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 2.5),
                                    blurRadius: 1.5,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  )
                                ]),
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
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SingleChildScrollView(
                      child: Text("${widget.tale.story}\n",
                          style: TextStyle(fontSize: 14),
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
}
