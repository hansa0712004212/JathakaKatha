import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icomoon_icons/flutter_icomoon_icons.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:jathakakatha/data/sinhala.dart';
import 'package:jathakakatha/model/AppPreference.dart';
import 'package:jathakakatha/model/Tale.dart';
import 'package:jathakakatha/ui/story.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchTextController;
  String _searchKey = "";
  List<String> _recentIds;
  bool _isRecentEnabled = false;
  AppPreference appPreference;

  @override
  void initState() {
    super.initState();
    _searchKey = "";
    _isRecentEnabled = false;
    _searchTextController = TextEditingController();
    getSharedPreferences();
  }

  Future<Null> getSharedPreferences() async {
    appPreference = await AppPreference.getInstance();
    setState(() {
      _recentIds = appPreference.recentIds;
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "$constPansiyaPanas $constAppName",
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: constFontSizeTitle, fontWeight: FontWeight.bold),
          ),
          backgroundColor: constColorPrimary,
          leading: Padding(
            padding: EdgeInsets.fromLTRB(constPaddingSpace, 0, 0, 0),
            child: Image(image: constImageAppIcon, fit: BoxFit.cover),
          ),
          actions: <Widget>[
            IconButton(
                icon: IconShadowWidget(
                    Icon(
                        _isRecentEnabled
                            ? IcoMoonIcons.list2
                            : IcoMoonIcons.history,
                        color: constColorIcon),
                    showShadow: false,
                    shadowColor: constColorIcon),
                color: constColorIcon,
                splashColor: constColorIconSplash,
                onPressed: () {
                  setState(() {
                    _isRecentEnabled = !_isRecentEnabled;
                  });
                })
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(constPaddingSpace),
                child: TextField(
                  controller: _searchTextController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(constBorderRadius),
                          borderSide: BorderSide(
                              width: constBorderWidth,
                              color: constColorPrimary)),
                      hintText: constSearch,
                      fillColor: constColorDefaultFill,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: constTextContentPadding),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(constBorderRadius),
                          borderSide: BorderSide(
                              width: constBorderWidth,
                              color: constColorDefaultDisabled)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(constBorderRadius),
                          borderSide: BorderSide(
                              width: constBorderWidth,
                              color: constColorPrimary)),
                      prefixIcon: Icon(IcoMoonIcons.search,
                          size: constIconSize, color: constColorPrimary),
                      suffixIcon: IconButton(
                          icon: Icon(IcoMoonIcons.cross,
                              size: constIconSize, color: constColorPrimary),
                          onPressed: clearSearch)),
                  onChanged: (String searchKey) async {
                    setState(() {
                      _searchKey = searchKey;
                      _isRecentEnabled = false;
                    });
                  },
                ),
              ),
              Container(
                child: Expanded(
                  child: GridView.count(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 2
                          : 4,
                      childAspectRatio: 2,
                      padding: EdgeInsets.all(constPaddingSpace),
                      mainAxisSpacing: constPaddingSpace,
                      crossAxisSpacing: constPaddingSpace,
                      children: getTales().map((Tale tale) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Story(tale: tale)));
                          },
                          child: GridTile(
                              header: Padding(
                                padding: EdgeInsets.all(constPaddingSpace),
                                child: Text(
                                  tale.id.toString(),
                                  style: TextStyle(
                                      color: constColorDefaultText,
                                      fontSize: constFontSizeTileIndex,
                                      fontWeight: FontWeight.bold,
                                      shadows: constDefaultTextShadow),
                                ),
                              ),
                              footer: Padding(
                                padding: EdgeInsets.all(constPaddingSpace),
                                child: Text(
                                  tale.title,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: constColorDefaultText,
                                      fontSize: constFontSizeTileTitle,
                                      fontWeight: FontWeight.bold,
                                      shadows: constDefaultTextShadow),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(constBorderRadius),
                                child: Hero(
                                  tag: tale.id,
                                  child: Image(
                                    image: AssetImage(tale.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                        );
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
          title: Text(constExit),
          content: Text(constExitConfirmMessage),
          actions: [
            FlatButton(
              child: Text(constYes),
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
            FlatButton(
              child: Text(constNo),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
    );
  }

  List<Tale> getTales() {
    if (_searchKey.length > 0) {
      List<Tale> filtered = tales
          .where((Tale tale) => tale.tags
              .toString()
              .toLowerCase()
              .contains(_searchKey.toLowerCase()))
          .toList();
      return filtered;
    } else if (_isRecentEnabled) {
      List<Tale> recentList = [];
      _recentIds.forEach((id) {
        Tale recentTale = tales.firstWhere((tale) => tale.id == int.parse(id));
        recentList.add(recentTale);
      });
      return recentList.reversed.toList();
    } else {
      return tales;
    }
  }

  void clearSearch() {
    _searchTextController.clear();
    setState(() {
      _searchKey = "";
    });
  }
}
