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
  ScrollController _gridViewController;
  String _searchKey = "";
  List<String> _recentIds;
  bool _isRecentEnabled = false;
  AppPreference appPreference;
  List<bool> _rangeToggle;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
    _searchKey = "";
    _isRecentEnabled = false;
    _searchTextController = TextEditingController();
    _gridViewController =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false);
    _rangeToggle = List.generate(6, (index) => index == 0 ? true : false);
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
          elevation: 0,
          bottomOpacity: 1.0,
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
                    _scrollToTop();
                  });
                })
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [constColorPrimary, constColorDefaultText],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 1])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(constPaddingSpace),
                child: TextField(
                  controller: _searchTextController,
                  cursorColor: constColorPrimary,
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
                              color: constColorTransparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(constBorderRadius),
                          borderSide: BorderSide(
                              width: constBorderWidth,
                              color: constColorPrimary)),
                      prefixIcon: Icon(IcoMoonIcons.search,
                          size: constIconSize, color: constColorPrimary),
                      suffixIcon: _searchKey.length > 0
                          ? IconButton(
                              icon: Icon(IcoMoonIcons.cross,
                                  size: constIconSize,
                                  color: constColorPrimary),
                              onPressed: clearSearch)
                          : Container(height: 0)),
                  onChanged: (String searchKey) async {
                    setState(() {
                      _searchKey = searchKey;
                      _isRecentEnabled = false;
                    });
                  },
                  style: TextStyle(
                      color: constColorPrimary,
                      fontSize: constFontSizeTileTitle),
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
                      controller: _gridViewController,
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
              !_isRecentEnabled
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: constPaddingSpace / 2),
                      child: ToggleButtons(
                        children: _getToggleButtons(),
                        isSelected: _rangeToggle,
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < _rangeToggle.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                _rangeToggle[buttonIndex] = true;
                              } else {
                                _rangeToggle[buttonIndex] = false;
                              }
                            }
                          });
                          _scrollToTop();
                        },
                        fillColor: constColorPrimary,
                        borderRadius: BorderRadius.circular(constBorderRadius),
                        borderWidth: 0.5,
                        borderColor: constColorPrimary,
                        selectedBorderColor: constColorPrimary,
                        splashColor: constColorPrimary.withAlpha(50),
                        highlightColor: constColorPrimary.withAlpha(100),
                        hoverColor: constColorPrimary.withAlpha(50),
                      ),
                    )
                  : Container(height: 0)
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
      int selectedRange = _rangeToggle.indexOf(true);
      return tales.sublist(
          (selectedRange * 10),
          ((selectedRange + 1) *
              10)); //TODO change value 10 to 100 when stories are filled
    }
  }

  void clearSearch() {
    _searchTextController.clear();
    setState(() {
      _searchKey = "";
    });
  }

  void _scrollToTop() {
    _gridViewController.animateTo(
      _gridViewController.position.minScrollExtent,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.ease,
    );
  }

  List<Widget> _getToggleButtons() {
    List<String> toggleButtonText = [
      "  1-\n100",
      "101-\n200",
      "201-\n300",
      "301-\n400",
      "401-\n500",
      "501-\n550"
    ];
    List<Container> toggleButtons = [];
    toggleButtonText.asMap().forEach((key, value) {
      toggleButtons.add(Container(
          width: (MediaQuery.of(context).size.width - 20) /
              _rangeToggle.length, //_toggleButtonContainerWidth,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                value,
                style: TextStyle(
                    color: _rangeToggle[key]
                        ? constColorDefaultText
                        : constColorPrimary,
                    fontWeight:
                        _rangeToggle[key] ? FontWeight.bold : FontWeight.normal,
                    shadows: _rangeToggle[key]
                        ? [
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 2.5,
                              color: constColorDefaultText,
                            ),
                          ]
                        : [
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 2.5,
                              color: constColorPrimary,
                            ),
                          ]),
              )
            ],
          )));
    });
    return toggleButtons;
  }
}
