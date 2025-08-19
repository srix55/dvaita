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
    String themeDefinitions = _getThemeDefinitions();
    String fontDefinitions = _getFontDefinitions();
    return '''
/* ${Constants.autoGenComment} */    
    
html {
  /* Links within the page are scrolled to smoothly instead of jumping */
  scroll-behavior: smooth;

  /* Smooth transition for colors, backgrounds, borders */
  transition: 
    background-color 0.3s ease,
    color 0.3s ease;
}

body, header, footer, main, a, button {
  transition: 
    background-color 0.3s ease,
    color 0.3s ease,
    border-color 0.3s ease;
} 

/* Disable transitions until page is fully initialized */
.no-transitions * {
  transition: none !important;
}
    
$themeDefinitions
    
body {
    margin: ${Settings.spacing.pageMargin};
    background-color: var(--background);
    color: var(--text);
    font-family: "${sanFonts.textFontFamily}", sans-serif;
    font-weight: ${sanFonts.textWeight};
    font-style: normal;
    line-height: ${Settings.spacing.lineHeight};
    font-variation-settings:
            "wdth" 100;
}

p {
    margin-top: ${Settings.spacing.paraMarginTopBottom};
    margin-bottom: ${Settings.spacing.paraMarginTopBottom};
}

body a {
    text-decoration: none;
    color: var(--text);
}

.theme-button {
  cursor: pointer;
  user-select: none;
  margin-left: 15px;
  color: var(--text);
  fill: var(--text);
}

a.book-link {
    color: var(--text);
    font-size: 21px;
}

header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

header a {
    font-size: 16px;
    color: var(--text);
    margin-left: auto;
    display: inline-flex; /* makes icon+text align properly */
    align-items: center;  /* vertical centering */    
}

footer {
    margin-top: 60px;
    font-size: 12px;
    color: var(--text);
}

hr {
    display: block;
    margin-top: ${Settings.spacing.dividerMarginTop};
    margin-bottom: ${Settings.spacing.dividerMarginBottom};
    border: none;
    border-top: 1px solid var(--divider);
}

.next,
.previous {
    display: inline-block;
    font-size: 15px;
    margin-right: 15px;
    color: var(--accent);
    margin-top: 5px;
    margin-bottom: 10px;
}

.chapter-links,
.moola-links {
    border: 1px solid var(--divider);
    border-radius: 5px;
    padding: 15px;
    margin-top: 30px;
    margin-bottom: 40px;
    font-size: 14px;
    color: var(--text);
}

.chapter-title {
    margin-bottom: 25px;
    color: var(--text);
}

.shloka {
    text-align: center;
    color: var(--shloka);
    margin-bottom: 10px;
}

.anvaya {
    color: var(--anvaya);
    line-height: ${Settings.spacing.lineHeightToContainInline};
}

.meta-heading {
    margin-bottom: ${Settings.spacing.metaHeadingMarginBottom};
    margin-top: ${Settings.spacing.metaHeadingMarginBottom};
    color: var(--meta-heading);
}

/* This is to accommodate inline-superscript text */
.extra-line-height {
    line-height: ${Settings.spacing.lineHeightToContainInline};
}

.landing-title {
    font-family: "${sanFonts.textFontFamily}", sans-serif;
    font-optical-sizing: auto;
    font-weight: 500;
    font-size: 40px;
    text-align: center;
    color: var(--text);
    font-style: normal;
    font-variation-settings:
            "wdth" 100;
}

.superscript-links-container {
    margin-left: 4px;
    margin-right: 4px;
    user-select: none;
}

.superscript-links-container:first-child {
    margin-left: 0px;
}

.meaning-link,
.grammar-link,
.ps-link {
    vertical-align: super;
    font-weight: ${sanFonts.inlineWeight};
    font-size: ${sanFonts.inlineSize};
    margin-left: 1px;
    color: var(--text);
    text-decoration: none;
}

.meaning-link:hover,
.grammar-link:hover,
.ps-link:hover {
    text-decoration: overline;
    color: var(--accent);
    text-decoration-color: var(--accent);
}

.inline {
    vertical-align: baseline;
    position: absolute;
    top: ${Settings.spacing.inlineTextOffset};
    left: -30px;
    width: 150px;
    color: var(--inline-meaning);
    user-select: none;
}

.meanings-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 400px));
    justify-content: center;
    column-gap: 10px;
    row-gap: 0;
    /*max-width: 900px;*/  /* or whatever feels good */
    margin: 0 auto;    /* centers the grid */
}

.word-with-meaning {
}

.meaning-word {
    color: var(--meaning-word);
}

.dotted-underline {
    border-bottom: 1px dashed var(--inline-meaning);
    text-decoration: none; /* prevent default underline */
}

/* Font definitions */
$fontDefinitions
    ''';
  }

  String _getFontDefinitions() {
    StringBuffer buff = StringBuffer();
    for (Fonts f in Settings.font.fonts) {
      String lang = f.lang;
      buff.writeln('.$lang {');
      buff.writeln('  font-family: "${f.textFontFamily}", sans-serif;');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-chapter-title {');
      buff.writeln('  font-family: "${f.chapterTitleFontFamily}", sans-serif;');
      buff.writeln('  font-weight: ${f.chapterTitleWeight};');
      buff.writeln('  font-size: ${f.chapterTitleSize};');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-secondary-heading {');
      buff.writeln('  font-family: "${f.secondaryHeadingFontFamily}", sans-serif;');
      buff.writeln('  font-weight: ${f.secondaryHeadingWeight};');
      buff.writeln('  font-size: ${f.secondaryHeadingSize};');
      buff.writeln('  color: var(--text);');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-meta-heading {');
      buff.writeln('  font-family: "${f.metaHeadingFontFamily}", sans-serif;');
      buff.writeln('  font-weight: ${f.metaHeadingWeight};');
      buff.writeln('  font-size: ${f.metaHeadingSize};');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-text {');
      buff.writeln('  font-family: "${f.textFontFamily}", sans-serif;');
      buff.writeln('  font-size: ${f.textSize};');
      buff.writeln('  font-weight: ${f.textWeight};');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-shloka {');
      buff.writeln('  font-family: "${f.shlokaFontFamily}", sans-serif;');
      buff.writeln('  font-size: ${f.shlokaSize};');
      buff.writeln('  font-weight: ${f.shlokaWeight};');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-gadya-meta {');
      buff.writeln('  font-family: "${f.gadyaMetaFontFamily}", sans-serif;');
      buff.writeln('  font-size: ${f.gadyaMetaSize};');
      buff.writeln('  font-weight: ${f.gadyaMetaWeight};');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-gadya {');
      buff.writeln('  font-family: "${f.gadyaFontFamily}", sans-serif;');
      buff.writeln('  font-size: ${f.gadyaSize};');
      buff.writeln('  font-weight: ${f.gadyaWeight};');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-ps {');
      buff.writeln('  font-family: "${f.psFontFamily}", sans-serif;');
      buff.writeln('  font-size: ${f.psSize};');
      buff.writeln('  font-weight: ${f.psWeight};');
      buff.writeln('}');
      buff.writeln('');
      buff.writeln('.$lang-inline {');
      buff.writeln('  font-family: "${f.inlineFontFamily}", sans-serif;');
      buff.writeln('  font-size: ${f.inlineSize};');
      buff.writeln('  font-weight: ${f.inlineWeight};');
      buff.writeln('}');
      buff.writeln('');
    }
    return buff.toString();
  }

  String _getThemeDefinitions() {
    StringBuffer buff = StringBuffer();
    buff.writeln(':root {');
    for (ColorTheme theme in Settings.allColorThemes) {
      buff.writeln('  /* ${theme.id}:${theme.name}:light */');
      buff.writeln('  --${theme.id}-light-background: #${theme.light.background};');
      buff.writeln('  --${theme.id}-light-accent: #${theme.light.accent};');
      buff.writeln('  --${theme.id}-light-meta-heading: #${theme.light.metaHeading};');
      buff.writeln('  --${theme.id}-light-inline-word: #${theme.light.inlineWord};');
      buff.writeln('  --${theme.id}-light-text: #${theme.light.text};');
      buff.writeln('  --${theme.id}-light-shloka: #${theme.light.shloka};');
      buff.writeln('  --${theme.id}-light-gadya: #${theme.light.gadya};');
      buff.writeln('  --${theme.id}-light-anvaya: #${theme.light.anvaya};');
      buff.writeln('  --${theme.id}-light-ps: #${theme.light.ps};');
      buff.writeln('  --${theme.id}-light-inline-meaning: #${theme.light.inlineMeaning};');
      buff.writeln('  --${theme.id}-light-meaning-word: #${theme.light.meaningWord};');
      buff.writeln('  --${theme.id}-light-divider: #${theme.light.divider};');
      buff.writeln('');
      buff.writeln('  /* ${theme.id}:${theme.name}:dark */');
      buff.writeln('  --${theme.id}-dark-background: #${theme.dark.background};');
      buff.writeln('  --${theme.id}-dark-accent: #${theme.dark.accent};');
      buff.writeln('  --${theme.id}-dark-meta-heading: #${theme.dark.metaHeading};');
      buff.writeln('  --${theme.id}-dark-inline-word: #${theme.dark.inlineWord};');
      buff.writeln('  --${theme.id}-dark-text: #${theme.dark.text};');
      buff.writeln('  --${theme.id}-dark-shloka: #${theme.dark.shloka};');
      buff.writeln('  --${theme.id}-dark-gadya: #${theme.dark.gadya};');
      buff.writeln('  --${theme.id}-dark-anvaya: #${theme.dark.anvaya};');
      buff.writeln('  --${theme.id}-dark-ps: #${theme.dark.ps};');
      buff.writeln('  --${theme.id}-dark-inline-meaning: #${theme.dark.inlineMeaning};');
      buff.writeln('  --${theme.id}-dark-meaning-word: #${theme.dark.meaningWord};');
      buff.writeln('  --${theme.id}-dark-divider: #${theme.dark.divider};');
    }
    buff.writeln('}');
    buff.writeln('');
    for (ColorTheme theme in Settings.allColorThemes) {
      buff.writeln('html[data-theme="${theme.id}"][data-mode="light"] {');
      buff.writeln('  --background: var(--${theme.id}-light-background);');
      buff.writeln('  --accent: var(--${theme.id}-light-accent);');
      buff.writeln('  --meta-heading: var(--${theme.id}-light-meta-heading);');
      buff.writeln('  --inline-word: var(--${theme.id}-light-inline-word);');
      buff.writeln('  --text: var(--${theme.id}-light-text);');
      buff.writeln('  --shloka: var(--${theme.id}-light-shloka);');
      buff.writeln('  --gadya: var(--${theme.id}-light-gadya);');
      buff.writeln('  --anvaya: var(--${theme.id}-light-anvaya);');
      buff.writeln('  --ps: var(--${theme.id}-light-ps);');
      buff.writeln('  --inline-meaning: var(--${theme.id}-light-inline-meaning);');
      buff.writeln('  --meaning-word: var(--${theme.id}-light-meaning-word);');
      buff.writeln('  --divider: var(--${theme.id}-light-divider);');
      buff.writeln('}');
      buff.write('');
      buff.writeln('html[data-theme="${theme.id}"][data-mode="dark"] {');
      buff.writeln('  --background: var(--${theme.id}-dark-background);');
      buff.writeln('  --accent: var(--${theme.id}-dark-accent);');
      buff.writeln('  --meta-heading: var(--${theme.id}-dark-meta-heading);');
      buff.writeln('  --inline-word: var(--${theme.id}-dark-inline-word);');
      buff.writeln('  --text: var(--${theme.id}-dark-text);');
      buff.writeln('  --shloka: var(--${theme.id}-dark-shloka);');
      buff.writeln('  --gadya: var(--${theme.id}-dark-gadya);');
      buff.writeln('  --anvaya: var(--${theme.id}-dark-anvaya);');
      buff.writeln('  --ps: var(--${theme.id}-dark-ps);');
      buff.writeln('  --inline-meaning: var(--${theme.id}-dark-inline-meaning);');
      buff.writeln('  --meaning-word: var(--${theme.id}-dark-meaning-word);');
      buff.writeln('  --divider: var(--${theme.id}-dark-divider);');
      buff.writeln('}');
    }
    return buff.toString();
  }
}