import 'package:flutter/material.dart';
import 'package:flutter_icomoon_icons/flutter_icomoon_icons.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:jathakakatha/data/sinhala.dart';
import 'package:jathakakatha/model/Tale.dart';
import 'package:jathakakatha/ui/story.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "550 ජාතක කතා",
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amber,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Image(
                image: AssetImage("assets/buddha_baby.png"), fit: BoxFit.cover),
          ),
          actions: <Widget>[
            IconButton(
                icon: IconShadowWidget(
                    Icon(IcoMoonIcons.history, color: Colors.white),
                    showShadow: false,
                    shadowColor: Colors.white),
                color: Colors.white,
                splashColor: Colors.orange,
                onPressed: () {
                  print("IcoMoon Icon Pressed! It's Home!");
                }),
            IconButton(
                icon: IconShadowWidget(
                    Icon(IcoMoonIcons.cog, color: Colors.white),
                    showShadow: false,
                    shadowColor: Colors.white),
                color: Colors.white,
                splashColor: Colors.orange,
                onPressed: () {
                  print("IcoMoon Icon Pressed! It's Home!");
                })
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(width: 0.8, color: Colors.amber)),
                      hintText: "Search",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(width: 0.8, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(width: 0.8, color: Colors.amber)),
                      prefixIcon: Icon(IcoMoonIcons.search,
                          size: 20, color: Colors.amber),
                      suffixIcon: Icon(IcoMoonIcons.cross,
                          size: 20, color: Colors.amber)),
                ),
              ),
              Container(
                child: Expanded(
                  child: GridView.count(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 2
                          : 4,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(10.0),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      children: tales.map((Tale tale) {
                        return GridTile(
                            header: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tale.id.toString(),
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
                            ),
                            footer: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tale.title,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 2.5),
                                        blurRadius: 1.5,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      )
                                    ]),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Story(tale: tale)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Hero(
                                  tag: tale.id,
                                  child: Image(
                                    image: AssetImage(tale.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ));
                      }).toList()),
                ),
              ),
              //_buildTales()
            ],
          ),
        ),
      ),
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Exit'),
          content: Text('Do you really want to exit ?'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () => Navigator.pop(c, true),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
    );
  }
}
