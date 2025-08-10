import 'dart:convert';
import 'dart:io';

import 'package:site_builder_dart/util/helper.dart';
import 'package:path/path.dart' as p;

class CssGen {
  static void generate(String publicSiteFolder) {
    final cssFile = File(p.join(publicSiteFolder, 'main.css'));
    final cssFileText = getText();
    cssFile.writeAsStringSync(cssFileText, encoding: utf8);
    print('Wrote ${cssFile.path}');
  }

  static String getText() {
    var spacingYaml = Helper.getYamlAsString(p.join('lib', 'settings', 'spacing.yaml'));
    var colorsYaml = Helper.getYamlAsString(p.join('lib', 'settings', 'colors.yaml'));
    String pageMargin = spacingYaml['page-margin'] ?? '15px';
    String backgroundColor = colorsYaml['color-themes']['theme1']['light']['background'] ?? 'white';
    String textColor = colorsYaml['color-themes']['theme1']['light']['text'] ?? 'black';
    return '''
body {
    margin: $pageMargin;
    background-color: #$backgroundColor;
    color: #$textColor;
    font-family: "Noto Sans Devanagari", sans-serif;
    font-weight: 300;
    font-style: normal;
    font-variation-settings:
            "wdth" 100;
}

body a {
    text-decoration: none;
    color: #$textColor;
}

footer {
    margin-top: 40px;
}

header h1 {
    font-family: "Noto Sans Devanagari", sans-serif;
    font-optical-sizing: auto;
    font-weight: 500;
    font-size: 40px;
    text-align: center;
    font-style: normal;
    font-variation-settings:
            "wdth" 100;
}    
    ''';
  }
}