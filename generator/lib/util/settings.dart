// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:collection';

import 'package:path/path.dart' as p;
import 'helper.dart';

class Settings {
  static late final ColorTheme color;
  static late final FontTheme font;
  static late final SpacingTheme spacing;
  static late final Config config;

  static late final List<ColorTheme> allColorThemes;
  static late final List<FontTheme> allFontThemes;
  static late final List<SpacingTheme> allSpacingThemes;

  static bool _isInitialized = false;
  static void init(String settingsLocation) {
    if (_isInitialized) return;
    _initializeColors(settingsLocation);
    _initializeFonts(settingsLocation);
    _initializeSpacing(settingsLocation);
    _initializeConfig(settingsLocation);
    _isInitialized = true;
  }

  static void _initializeConfig(String settingsLocation) {
    var configYaml = Helper.getYamlAsString(p.join(settingsLocation, 'config.yaml')) as Map;
    config = Config(
        shouldGenerateHtml: configYaml['should-generate-html'] == 'yes' ? true : false,
        shouldGeneratePdf: configYaml['should-generate-pdf'] == 'yes' ? true : false,
        shouldGenerateOdt: configYaml['should-generate-odt'] == 'yes' ? true : false,
        htmlOutputDirectory: configYaml['html-output-dir'] ?? 'output',
        pdfOutputDirectory: configYaml['pdf-output-dir'] ?? 'output',
        odtOutputDirectory: configYaml['odt-output-dir'] ?? 'output',
        textsDirectory: configYaml['texts-dir'] ?? '../texts',
    );
  }

  static void _initializeSpacing(String settingsLocation) {
    var spacingYaml = Helper.getYamlAsString(p.join(settingsLocation, 'spacing.yaml'));
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

  static void _initializeFonts(String settingsLocation) {
    var fontsYaml = Helper.getYamlAsString(p.join(settingsLocation, 'fonts.yaml')) as Map;
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
              gadyaMetaFontFamily: langFonts['gadya-meta-font-family'],
              gadyaMetaSize: langFonts['gadya-meta-size'],
              gadyaMetaWeight: langFonts['gadya-meta-weight'],
              gadyaFontFamily: langFonts['gadya-font-family'],
              gadyaWeight: langFonts['gadya-weight'],
              gadyaSize: langFonts['gadya-size'],
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
  }

  static void _initializeColors(String settingsLocation) {
    var colorsYaml = Helper.getYamlAsString(p.join(settingsLocation, 'colors.yaml')) as Map;
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
          divider: light['divider'], gadya: light['gadya']);
      var dark = theme['dark'] as Map;
      Colors dar = Colors(background: dark['background'],
          inlineWord: dark['inline-word'], meaningWord: dark['meaning-word'],
          metaHeading: dark['meta-heading'], text: dark['text'], shloka: dark['shloka'],
          anvaya: dark['anvaya'], ps: dark['ps'], inlineMeaning: dark['inline-meaning'],
          divider: dark['divider'], gadya: dark['gadya']);
      ColorTheme colorTheme = ColorTheme(name: themeName, light: lite, dark: dar);
      allColorThemes.add(colorTheme);
      if (themeId == selectedColorThemeId)
        color = colorTheme;
    }
  }
}

class Config {
  final bool shouldGenerateHtml;
  final bool shouldGeneratePdf;
  final bool shouldGenerateOdt;
  final String htmlOutputDirectory;
  final String pdfOutputDirectory;
  final String odtOutputDirectory;
  final String textsDirectory;

  Config({required this.shouldGenerateHtml, required this.shouldGeneratePdf,
    required this.shouldGenerateOdt, required this.htmlOutputDirectory,
    required this.pdfOutputDirectory, required this.odtOutputDirectory,
    required this.textsDirectory});
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
  
  String getGoogleFontFetchURL() {
    Map<String, Set<int>> fontFamilyToWeight = HashMap<String, Set<int>>();
    for (Fonts f in fonts) {
      if (fontFamilyToWeight[f.chapterTitleFontFamily] == null) fontFamilyToWeight[f.chapterTitleFontFamily] = {};
      fontFamilyToWeight[f.chapterTitleFontFamily]!.add(int.parse(f.chapterTitleWeight));

      if (fontFamilyToWeight[f.secondaryHeadingFontFamily] == null) fontFamilyToWeight[f.secondaryHeadingFontFamily] = {};
      fontFamilyToWeight[f.secondaryHeadingFontFamily]!.add(int.parse(f.secondaryHeadingWeight));

      if (fontFamilyToWeight[f.metaHeadingFontFamily] == null) fontFamilyToWeight[f.metaHeadingFontFamily] = {};
      fontFamilyToWeight[f.metaHeadingFontFamily]!.add(int.parse(f.metaHeadingWeight));

      if (fontFamilyToWeight[f.textFontFamily] == null) fontFamilyToWeight[f.textFontFamily] = {};
      fontFamilyToWeight[f.textFontFamily]!.add(int.parse(f.textWeight));

      if (fontFamilyToWeight[f.shlokaMetaFontFamily] == null) fontFamilyToWeight[f.shlokaMetaFontFamily] = {};
      fontFamilyToWeight[f.shlokaMetaFontFamily]!.add(int.parse(f.shlokaMetaWeight));

      if (fontFamilyToWeight[f.shlokaFontFamily] == null) fontFamilyToWeight[f.shlokaFontFamily] = {};
      fontFamilyToWeight[f.shlokaFontFamily]!.add(int.parse(f.shlokaWeight));

      if (fontFamilyToWeight[f.gadyaMetaFontFamily] == null) fontFamilyToWeight[f.gadyaMetaFontFamily] = {};
      fontFamilyToWeight[f.gadyaMetaFontFamily]!.add(int.parse(f.gadyaMetaWeight));

      if (fontFamilyToWeight[f.gadyaFontFamily] == null) fontFamilyToWeight[f.gadyaFontFamily] = {};
      fontFamilyToWeight[f.gadyaFontFamily]!.add(int.parse(f.gadyaWeight));

      if (fontFamilyToWeight[f.psFontFamily] == null) fontFamilyToWeight[f.psFontFamily] = {};
      fontFamilyToWeight[f.psFontFamily]!.add(int.parse(f.psWeight));

      if (fontFamilyToWeight[f.inlineFontFamily] == null) fontFamilyToWeight[f.inlineFontFamily] = {};
      fontFamilyToWeight[f.inlineFontFamily]!.add(int.parse(f.inlineWeight));
    }
    return _buildGoogleFontsUrl(fontFamilyToWeight);
  }

  String _buildGoogleFontsUrl(Map<String, Set<int>> fontFamilyToWeight) {
    const baseUrl = 'https://fonts.googleapis.com/css2';
    final families = fontFamilyToWeight.entries.map((entry) {
      // Replace spaces with '+' for URL encoding of font names
      final fontName = entry.key.replaceAll(' ', '+');

      // Sort weights so URL is clean and deterministic
      final weights = entry.value.toList()..sort();

      if (weights.isEmpty) {
        return 'family=$fontName';
      } else {
        final weightList = weights.join(';');
        return 'family=$fontName:wght@$weightList';
      }
    }).join('&');

    return '$baseUrl?$families&display=swap';
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

  final String gadyaMetaFontFamily;
  final String gadyaMetaSize;
  final String gadyaMetaWeight;

  final String gadyaFontFamily;
  final String gadyaWeight;
  final String gadyaSize;

  final String psFontFamily;
  final String psWeight;
  final String psSize;

  final String inlineFontFamily;
  final String inlineWeight;
  final String inlineSize;

  Fonts({required this.lang, required this.chapterTitleFontFamily, 
    required this.chapterTitleWeight, required this.chapterTitleSize, 
    required this.secondaryHeadingFontFamily, required this.secondaryHeadingWeight, 
    required this.secondaryHeadingSize, required this.metaHeadingFontFamily, 
    required this.metaHeadingWeight, required this.metaHeadingSize, 
    required this.textFontFamily, required this.textSize, required this.textWeight, 
    required this.shlokaMetaFontFamily, required this.shlokaMetaSize, 
    required this.shlokaMetaWeight, required this.shlokaFontFamily, 
    required this.shlokaWeight, required this.shlokaSize, required this.psFontFamily, 
    required this.psWeight, required this.psSize, required this.inlineFontFamily,
    required this.gadyaFontFamily, required this.gadyaMetaFontFamily,
    required this.gadyaMetaSize, required this.gadyaMetaWeight, required this.gadyaSize,
    required this.gadyaWeight, required this.inlineWeight, required this.inlineSize});

  @override
  String toString() {
    return 'Fonts{lang: $lang, chapterTitleFontFamily: $chapterTitleFontFamily, chapterTitleWeight: $chapterTitleWeight, chapterTitleSize: $chapterTitleSize, secondaryHeadingFontFamily: $secondaryHeadingFontFamily, secondaryHeadingWeight: $secondaryHeadingWeight, secondaryHeadingSize: $secondaryHeadingSize, metaHeadingFontFamily: $metaHeadingFontFamily, metaHeadingWeight: $metaHeadingWeight, metaHeadingSize: $metaHeadingSize, textFontFamily: $textFontFamily, textSize: $textSize, textWeight: $textWeight, shlokaMetaFontFamily: $shlokaMetaFontFamily, shlokaMetaSize: $shlokaMetaSize, shlokaMetaWeight: $shlokaMetaWeight, shlokaFontFamily: $shlokaFontFamily, shlokaWeight: $shlokaWeight, shlokaSize: $shlokaSize, gadyaMetaFontFamily: $gadyaMetaFontFamily, gadyaMetaSize: $gadyaMetaSize, gadyaMetaWeight: $gadyaMetaWeight, gadyaFontFamily: $gadyaFontFamily, gadyaWeight: $gadyaWeight, gadyaSize: $gadyaSize, psFontFamily: $psFontFamily, psWeight: $psWeight, psSize: $psSize, inlineFontFamily: $inlineFontFamily, inlineWeight: $inlineWeight, inlineSize: $inlineSize}';
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
  final String gadya;
  final String anvaya;
  final String ps;
  final String inlineMeaning;
  final String meaningWord;
  final String divider;

  Colors({required this.background, required this.metaHeading, required this.inlineWord, required this.text, required this.shloka, required this.anvaya, required this.ps, required this.inlineMeaning, required this.meaningWord, required this.divider, required this.gadya});

  @override
  String toString() {
    return 'Colors{background: $background, metaHeading: $metaHeading, inlineWord: $inlineWord, text: $text, shloka: $shloka, anvaya: $anvaya, ps: $ps, inlineMeaning: $inlineMeaning, meaningWord: $meaningWord, divider: $divider, gadya: $gadya}';
  }
}