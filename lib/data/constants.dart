import 'package:flutter/material.dart';

// Strings
final String constPansiyaPanas = "550";
final String constAppName = "ජාතක කතා";
final String constSearch = "සොයන්න";
final String constExit = "පිටවීම";
final String constYes = "ඔව්";
final String constNo = "නැත";
final String constExitConfirmMessage =
    "$constPansiyaPanas $constAppName තුලින් ඉවත්වීමට අවශ්‍යද ?";
final String constTtsLanguage = "si-LK";
final int constTtsMaxLength = 3999;
final double constShadowTextBlurRadius = 2;
final String constAbout = "යෙදවුම පිලිබඳ";

// Colors
final Color constColorPrimary = Colors.amber;
final Color constColorSecondary = Colors.orange;
final Color constColorSplashNumberTitle = Color.fromARGB(255, 255, 191, 0);
final Color constColorSplashTextTitle = Color.fromARGB(255, 255, 0, 127);
final Color constColorDefaultText = Colors.white;
final Color constColorDefaultFill = Colors.white;
final Color constColorDefaultDisabled = Colors.grey;
final Color constColorIcon = Colors.white;
final Color constColorIconShadow = Colors.black;
final Color constColorTextShadow = Colors.black;
final Color constColorIconSplash = Colors.orange;
final Color constColorTransparent = Colors.transparent;

// Images
final AssetImage constWelcomeBackgroundImage =
    AssetImage("assets/lord-buddha.jpg");
final AssetImage constImageAppIcon = AssetImage("assets/buddha_baby.png");

// Font Sizes
final double constFontSizeTitle = 24;
final double constFontSizeTileIndex = 24;
final double constFontSizeTileTitle = 20;
final double constFontSizeStory = 16;
final double constFontSizeBody = 16;
const double constFontSizeStoryMax = 28;
const double constFontSizeStoryMin = 12;

// Border Sizes
final double constBorderRadius = 10;
final double constBorderWidth = 0.8;
final double constTextContentPadding = 10;
final double constIconSize = 20;
final double constPaddingSpace = 10;

// Lists, Arrays
List<Color> constColorsColourfulProgressBar = [
  Color.fromARGB(255, 0, 0, 255),
  Colors.yellow,
  Colors.red,
  Colors.white,
  Colors.orange
];

Map<String, double> fontSizeMap = <String, double>{
  "ඉතා සෙමෙන්": 0.6,
  "සෙමෙන්": 0.8,
  "සාමාන්‍ය": 1,
  "වේගයෙන්": 1.2,
  "ඉතා වේගයෙන්": 1.4
};

// Shadows
final Shadow constShadowTextUpRight = Shadow(
  offset: Offset(1.0, 1.5),
  blurRadius: constShadowTextBlurRadius,
  color: constColorTextShadow,
);
final Shadow constShadowTextDownRight = Shadow(
  offset: Offset(1.0, -1.5),
  blurRadius: constShadowTextBlurRadius,
  color: constColorTextShadow,
);
final Shadow constShadowTextDownLeft = Shadow(
  offset: Offset(-1.0, -1.5),
  blurRadius: constShadowTextBlurRadius,
  color: constColorTextShadow,
);
final Shadow constShadowTextUpLeft = Shadow(
  offset: Offset(-1.0, 1.5),
  blurRadius: constShadowTextBlurRadius,
  color: constColorTextShadow,
);
final List<Shadow> constDefaultTextShadow = <Shadow>[
  constShadowTextDownLeft,
  constShadowTextDownRight,
  constShadowTextUpRight,
  constShadowTextUpLeft
];
