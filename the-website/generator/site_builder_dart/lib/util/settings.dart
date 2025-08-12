// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:path/path.dart' as p;
import 'helper.dart';

class Settings {
  static late final ColorTheme color;
  static late final FontTheme font;
  static late final SpacingTheme spacing;

  static late final List<ColorTheme> allColorThemes;
  static late final List<FontTheme> allFontThemes;
  static late final List<SpacingTheme> allSpacingThemes;

  static bool _isInitialized = false;
  static void init() {
    if (_isInitialized) return;
    _initializeColors();
    _initializeFonts();
    _initializeSpacing();
    _isInitialized = true;
  }

  static void _initializeSpacing() {
    var spacingYaml = Helper.getYamlAsString(p.join('lib', 'settings', 'spacing.yaml'));
    var themes = spacingYaml['spacing-themes'] as Map;
    var selectedSpacingThemeId = spacingYaml['selected-theme'];
    allSpacingThemes = [];
    for (var themeKey in themes.keys) {
      String themeId = themeKey;
      var theme = themes[themeId] as Map;
      SpacingTheme spacingTheme = SpacingTheme(
          name: theme['name'],
          pageMargin: theme['page-margin'],
          pageMarginTopBottom: theme['para-margin-top-bottom'],
          chapterTitleMarginBottom: theme['chapter-title-margin-bottom'],
          dividerMarginTopBottom: theme['divider-margin-top-bottom'],
          metaHeadingToContent: theme['meta-heading-to-content'],
          shlokaMetaToShloka: theme['shloka-meta-to-shloka']
      );
      if (themeId == selectedSpacingThemeId)
        spacing = spacingTheme;
      allSpacingThemes.add(spacingTheme);
    }
  }

  static void _initializeFonts() {
    var fontsYaml = Helper.getYamlAsString(p.join('lib', 'settings', 'fonts.yaml')) as Map;
    var themes = fontsYaml['font-themes'] as Map;
    var selectedFontThemeId = fontsYaml['selected-theme'];
    allFontThemes = [];
    for (var themeKey in themes.keys) {
      String themeId = themeKey;
      var theme = themes[themeId] as Map;
      String themeName = theme['name'];
      List<Fonts> fontList = [];
      for (var langKey in theme.keys) {
        if (langKey.toString().length == 3) {
          var langFonts = theme[langKey] as Map;
          String lang = langKey.toString();
          Fonts fonts = Fonts(lang: lang,
              chapterTitleFontFamily: langFonts['chapter-title-font-family'],
              chapterTitleWeight: langFonts['chapter-title-weight'],
              chapterTitleSize: langFonts['chapter-title-size'],
              secondaryHeadingFontFamily: langFonts['secondary-heading-font-family'],
              secondaryHeadingWeight: langFonts['secondary-heading-weight'],
              secondaryHeadingSize: langFonts['secondary-heading-size'],
              metaHeadingFontFamily: langFonts['meta-heading-font-family'],
              metaHeadingWeight: langFonts['meta-heading-weight'],
              metaHeadingSize: langFonts['meta-heading-size'],
              textFontFamily: langFonts['text-font-family'],
              textSize: langFonts['text-size'],
              textWeight: langFonts['text-weight'],
              shlokaMetaFontFamily: langFonts['shloka-meta-font-family'],
              shlokaMetaSize: langFonts['shloka-meta-size'],
              shlokaMetaWeight: langFonts['shloka-meta-weight'],
              shlokaFontFamily: langFonts['shloka-font-family'],
              shlokaWeight: langFonts['shloka-weight'],
              shlokaSize: langFonts['shloka-size'],
              psFontFamily: langFonts['ps-font-family'],
              psWeight: langFonts['ps-weight'],
              psSize: langFonts['ps-size'],
              inlineFontFamily: langFonts['inline-font-family'],
              inlineWeight: langFonts['inline-weight'],
              inlineSize: langFonts['inline-size'],
          );
          fontList.add(fonts);
        }
      }
      FontTheme fontTheme = FontTheme(name: themeName, fonts: fontList);
      allFontThemes.add(fontTheme);
      if (selectedFontThemeId == themeId)
        font = fontTheme;
    }
    print('All font themes size: ${allFontThemes.length}');
    print('selectedFontTheme: $font');
  }

  static void _initializeColors() {
    var colorsYaml = Helper.getYamlAsString(p.join('lib', 'settings', 'colors.yaml')) as Map;
    var themes = colorsYaml['color-themes'] as Map;
    var selectedColorThemeId = colorsYaml['selected-theme'];
    allColorThemes = [];
    for (var themeKey in themes.keys) {
      String themeId = themeKey;
      var theme = themes[themeId] as Map;
      String themeName = theme['name'];
      var light = theme['light'] as Map;
      Colors lite = Colors(background: light['background'],
          inlineWord: light['inline-word'], meaningWord: light['meaning-word'],
          metaHeading: light['meta-heading'], text: light['text'], shloka: light['shloka'],
          anvaya: light['anvaya'], ps: light['ps'], inlineMeaning: light['inline-meaning'],
          divider: light['divider']);
      var dark = theme['dark'] as Map;
      Colors dar = Colors(background: dark['background'],
          inlineWord: dark['inline-word'], meaningWord: dark['meaning-word'],
          metaHeading: dark['meta-heading'], text: dark['text'], shloka: dark['shloka'],
          anvaya: dark['anvaya'], ps: dark['ps'], inlineMeaning: dark['inline-meaning'],
          divider: dark['divider']);
      ColorTheme colorTheme = ColorTheme(name: themeName, light: lite, dark: dar);
      allColorThemes.add(colorTheme);
      if (themeId == selectedColorThemeId)
        color = colorTheme;
    }
  }
}

class SpacingTheme {
  final String name;
  final String pageMargin;
  final String pageMarginTopBottom;
  final String chapterTitleMarginBottom;
  final String dividerMarginTopBottom;
  final String metaHeadingToContent;
  final String shlokaMetaToShloka;

  SpacingTheme({required this.name, required this.pageMargin, required this.pageMarginTopBottom, required this.chapterTitleMarginBottom, required this.dividerMarginTopBottom, required this.metaHeadingToContent, required this.shlokaMetaToShloka});

  @override
  String toString() {
    return 'SpacingTheme{name: $name, pageMargin: $pageMargin, pageMarginTopBottom: $pageMarginTopBottom, chapterTitleMarginBottom: $chapterTitleMarginBottom, dividerMarginTopBottom: $dividerMarginTopBottom, metaHeadingToContent: $metaHeadingToContent, shlokaMetaToShloka: $shlokaMetaToShloka}';
  }


}

class FontTheme {
  final String name;
  final List<Fonts> fonts;

  FontTheme({required this.name, required this.fonts});

  Fonts get({required String lang}) {
    for (Fonts f in fonts)
      if (f.lang == lang) return f;
    throw Exception('no such lang: $lang');
  }

  @override
  String toString() {
    return 'FontTheme{name: $name, fonts: $fonts}';
  }
}

class Fonts {
  final String lang; // 3 letter code
  final String chapterTitleFontFamily;
  final String chapterTitleWeight;
  final String chapterTitleSize;

  final String secondaryHeadingFontFamily;
  final String secondaryHeadingWeight;
  final String secondaryHeadingSize;

  final String metaHeadingFontFamily;
  final String metaHeadingWeight;
  final String metaHeadingSize;

  final String textFontFamily;
  final String textSize;
  final String textWeight;

  final String shlokaMetaFontFamily;
  final String shlokaMetaSize;
  final String shlokaMetaWeight;

  final String shlokaFontFamily;
  final String shlokaWeight;
  final String shlokaSize;

  final String psFontFamily;
  final String psWeight;
  final String psSize;

  final String inlineFontFamily;
  final String inlineWeight;
  final String inlineSize;

  Fonts({required this.lang, required this.chapterTitleFontFamily, required this.chapterTitleWeight, required this.chapterTitleSize, required this.secondaryHeadingFontFamily, required this.secondaryHeadingWeight, required this.secondaryHeadingSize, required this.metaHeadingFontFamily, required this.metaHeadingWeight, required this.metaHeadingSize, required this.textFontFamily, required this.textSize, required this.textWeight, required this.shlokaMetaFontFamily, required this.shlokaMetaSize, required this.shlokaMetaWeight, required this.shlokaFontFamily, required this.shlokaWeight, required this.shlokaSize, required this.psFontFamily, required this.psWeight, required this.psSize, required this.inlineFontFamily, required this.inlineWeight, required this.inlineSize});

  @override
  String toString() {
    return 'Fonts{lang: $lang, chapterTitleFontFamily: $chapterTitleFontFamily, chapterTitleWeight: $chapterTitleWeight, chapterTitleSize: $chapterTitleSize, secondaryHeadingFontFamily: $secondaryHeadingFontFamily, secondaryHeadingWeight: $secondaryHeadingWeight, secondaryHeadingSize: $secondaryHeadingSize, metaHeadingFontFamily: $metaHeadingFontFamily, metaHeadingWeight: $metaHeadingWeight, metaHeadingSize: $metaHeadingSize, textFontFamily: $textFontFamily, textSize: $textSize, textWeight: $textWeight, shlokaMetaFontFamily: $shlokaMetaFontFamily, shlokaMetaSize: $shlokaMetaSize, shlokaMetaWeight: $shlokaMetaWeight, shlokaFontFamily: $shlokaFontFamily, shlokaWeight: $shlokaWeight, shlokaSize: $shlokaSize, psFontFamily: $psFontFamily, psWeight: $psWeight, psSize: $psSize, inlineFontFamily: $inlineFontFamily, inlineWeight: $inlineWeight, inlineSize: $inlineSize}';
  }


}

class ColorTheme {
  final String name;
  final Colors light;
  final Colors dark;

  ColorTheme({required this.name, required this.light, required this.dark});

  @override
  String toString() {
    return 'ColorTheme{name: $name, light: $light, dark: $dark}';
  }
}

class Colors {
  final String background;
  final String metaHeading;
  final String inlineWord;
  final String text;
  final String shloka;
  final String anvaya;
  final String ps;
  final String inlineMeaning;
  final String meaningWord;
  final String divider;

  Colors({required this.background, required this.metaHeading, required this.inlineWord, required this.text, required this.shloka, required this.anvaya, required this.ps, required this.inlineMeaning, required this.meaningWord, required this.divider});

  @override
  String toString() {
    return 'Colors{background: $background, metaHeading: $metaHeading, inlineWord: $inlineWord, text: $text, shloka: $shloka, anvaya: $anvaya, ps: $ps, inlineMeaning: $inlineMeaning, meaningWord: $meaningWord, divider: $divider}';
  }
}