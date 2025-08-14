// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:generator/generators/site/page_generators/header_gen.dart';
import 'package:generator/models/book_type.dart';
import 'package:generator/models/string_with_lang.dart';
import 'package:generator/models/vyakhyana_info.dart';
import 'package:path/path.dart' as p;

import '../../../util/settings.dart';
import '../util/constants.dart';
import 'footer_gen.dart';
import 'head_gen.dart';

class BookIndexGen {
  final StringWithLang bookTitle;
  final List<StringWithLang> authors;
  final List<VyakhyanaInfo> vyakhyanas;
  final BookType bookType;
  final String bookId;
  final List<BookIndexChapterInfo> chapters;

  BookIndexGen({required this.bookTitle, required this.authors,
    required this.vyakhyanas, required this.bookType, required this.bookId,
    required this.chapters}); // without footer

  void generate() {
    final dir = Directory(p.join(Settings.config.htmlOutputDirectory, 'texts', bookId));
    dir.createSync();
    final htmlFile = File(p.join(Settings.config.htmlOutputDirectory, 'texts', bookId, '$bookId.html'));
    String headSection = HeadGen(folderLevel: 2 /* texts/bookId/bookId.html */, cssFileName: Constants.cssFileName, jsFileName: Constants.jsFileName, fontUrl: Settings.font.getGoogleFontFetchURL(), pageTitle: bookTitle.string).generate();
    String chapterLinks = _getChapterLinks();
    String htmlFinal = '''
<!doctype html>
<html lang="sa">
$headSection
<body>
${HeaderGen(folderLevel: 2).generate()}

  <div class="chapter-title ${bookTitle.lang}-chapter-title">${bookTitle.string}</div>
  ${_getAuthors()}
  ${_getVyakhyanas()}

  <main class="content">
    <div class="chapter-links">$chapterLinks</div>
  </main>

${FooterGen().generate()}
</body>
</html>
''';
    htmlFile.writeAsStringSync(htmlFinal, encoding: utf8);
  }

  String _getChapterLinks() {
    String chapterLinks = '';
    for (int i=0; i<chapters.length; i++) {
      BookIndexChapterInfo info = chapters[i];
      bool first = i==0;
      chapterLinks = '$chapterLinks<a href="${info.chapterId}/${info.chapterId}.html" ${first ? '' : 'style="margin-left: 2em;" class="${info.chapter.lang}"'}>${info.chapter.string}</a>';
    }
    return chapterLinks;
  }

  String _getAuthors() {
    if (authors.isEmpty) return '';
    StringBuffer buff = StringBuffer();
    if (authors.length > 1) buff.writeln('<div class="san-text" style="text-decoration: underline">ग्रन्थकर्तारः :-</div>');
    else buff.write('<div><span class="san-text" style="text-decoration: underline">ग्रन्थकर्ता</span>');
    for (StringWithLang author in authors) {
      if (authors.length > 1) buff.writeln('<div class="${author.lang}-text">${author.string}</div>');
      else buff.write('<span class="${author.lang}-text">&nbsp;-&nbsp;${author.string}</span></div>');
    }
    return buff.toString();
  }

  String _getVyakhyanas() {
    if (vyakhyanas.isEmpty) return '';
    StringBuffer buff = StringBuffer();
    buff.writeln('<br>');
    if (vyakhyanas.length > 1) buff.writeln('<div class="san-text" style="text-decoration: underline">व्याख्यानानि :-</div>');
    else buff.write('<div><span class="san-text" style="text-decoration: underline">व्याख्यानम् - </span>');
    for (VyakhyanaInfo vyInfo in vyakhyanas) {
      if (vyakhyanas.length > 1) buff.writeln('<div><span class="${vyInfo.title.lang}-text">${vyInfo.title.string}</span><span class="san-text">&nbsp;-&nbsp;</span><span class="${vyInfo.author.lang}-text">${vyInfo.author.string}</span></div>');
      else buff.write('<span class="${vyInfo.title.lang}-text">${vyInfo.title.string}</span><span class="san-text">&nbsp;-&nbsp;</span><span class="${vyInfo.author.lang}-text">${vyInfo.author.string}</span></div>');
    }
    return buff.toString();
  }
}

class BookIndexChapterInfo {
  final StringWithLang chapter;
  final String chapterId;

  BookIndexChapterInfo({required this.chapter, required this.chapterId});
}