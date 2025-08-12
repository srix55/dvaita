import 'dart:convert';
import 'dart:io';

import 'package:generator/generators/site/util/constants.dart';
import 'package:generator/util/settings.dart';
import 'package:path/path.dart' as p;

class CssGen {
  void generate() {
    final cssFile = File(p.join(Settings.config.htmlOutputDirectory, Constants.cssFileName));
    final cssFileText = _getText();
    cssFile.writeAsStringSync(cssFileText, encoding: utf8);
  }

  String _getText() {
    Fonts sanFonts = Settings.font.fonts.firstWhere((font) => font.lang == 'san');
    return '''
body {
    margin: ${Settings.spacing.pageMargin};
    background-color: #${Settings.color.light.background};
    color: #${Settings.color.light.text};
    font-family: "${sanFonts.textFontFamily}", sans-serif;
    font-weight: ${sanFonts.textWeight};
    font-style: normal;
    font-variation-settings:
            "wdth" 100;
}

body a {
    text-decoration: none;
    color: #${Settings.color.light.text};
}

a.book-link {
    color: #4A5759;
    font-size: 21px;
}

footer {
    margin-top: 40px;
    font-size: 12px;
    color: #4A5759;
}

header h1 {
    font-family: "${sanFonts.textFontFamily}", sans-serif;
    font-optical-sizing: auto;
    font-weight: 500;
    font-size: 40px;
    text-align: center;
    color: #4A5759;
    font-style: normal;
    font-variation-settings:
            "wdth" 100;
}    
    ''';
  }
}