// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:generator/generators/site/page_generators/page_gen.dart';
import 'package:generator/models/book_info.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:generator/util/settings.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

import '../../../models/string_with_lang.dart';
import '../../../models/vyakhyana_info.dart';

class BookIndexXmlHandler {
  final XmlElement bookXml;
  late final BookInfo bookInfo;

  BookIndexXmlHandler({required this.bookXml, required this.bookInfo}) {
    if (bookXml.localName != XmlTag.book.tag)
      throw Exception('$BookIndexXmlHandler: XmlElement is supposed to be a book-element');
  }

  void handle() {
    final dir = Directory(p.join(Settings.config.htmlOutputDirectory, 'texts', bookInfo.bookId));
    dir.createSync();
    String htmlContent = '''
  <div class="chapter-title ${bookInfo.bookTitle.lang}-chapter-title">${bookInfo.bookTitle.string}</div>
  ${_getAuthors()}
  ${_getVyakhyanas()}

  <main class="content">
    <div class="chapter-links">${_getChapterLinks()}</div>
  </main>    
    ''';
    PageGen(pageTitle: bookInfo.bookTitle.string, folderLevel: 2, fileName: '${bookInfo.bookId}.html', htmlContent: htmlContent, outputDir: p.join(Settings.config.htmlOutputDirectory, 'texts', bookInfo.bookId)).generate();
  }

  void _recursiveHandler(XmlElement xml) {

  }

  List<BookIndexChapterInfo> _getChapters() {
    List<BookIndexChapterInfo> infoList = [];
    List<XmlElement> chapterElements = bookXml.findAllElements(XmlTag.chapter.tag).toList();
    for (XmlElement chapter in chapterElements) {
      String chapterName = chapter.getAttribute(Attribute.name.tag)!;
      String chapterNumber = chapter.getAttribute(Attribute.number.tag)!;
      String lang = chapter.getAttribute(Attribute.lang.tag)!;
      BookIndexChapterInfo info = BookIndexChapterInfo(chapter: StringWithLang(string: chapterName, lang: lang), chapterId: chapterNumber);
      infoList.add(info);
    }
    return infoList;
  }

  String _getChapterLinks() {
    List<BookIndexChapterInfo> chapters = _getChapters();
    String chapterLinks = '';
    for (int i=0; i<chapters.length; i++) {
      BookIndexChapterInfo info = chapters[i];
      bool first = i==0;
      chapterLinks = '$chapterLinks<a href="${info.chapterId}/${info.chapterId}.html" ${first ? '' : 'style="margin-left: 2em;" class="${info.chapter.lang}"'}>${info.chapter.string}</a>';
    }
    return chapterLinks;
  }

  String _getAuthors() {
    if (bookInfo.bookAuthors.isEmpty) return '';
    StringBuffer buff = StringBuffer();
    if (bookInfo.bookAuthors.length > 1) buff.writeln('<div class="san-text" style="text-decoration: underline">ग्रन्थकर्तारः :-</div>');
    else buff.write('<div><span class="san-text" style="text-decoration: underline">ग्रन्थकर्ता</span>');
    for (StringWithLang author in bookInfo.bookAuthors) {
      if (bookInfo.bookAuthors.length > 1) buff.writeln('<div class="${author.lang}-text">${author.string}</div>');
      else buff.write('<span class="${author.lang}-text">&nbsp;-&nbsp;${author.string}</span></div>');
    }
    return buff.toString();
  }

  String _getVyakhyanas() {
    if (bookInfo.vyakhyanaInfoList.isEmpty) return '';
    StringBuffer buff = StringBuffer();
    buff.writeln('<br>');
    if (bookInfo.vyakhyanaInfoList.length > 1) buff.writeln('<div class="san-text" style="text-decoration: underline">व्याख्यानानि :-</div>');
    else buff.write('<div><span class="san-text" style="text-decoration: underline">व्याख्यानम् - </span>');
    for (VyakhyanaInfo vyInfo in bookInfo.vyakhyanaInfoList) {
      if (bookInfo.vyakhyanaInfoList.length > 1) buff.writeln('<div><span class="${vyInfo.title.lang}-text">${vyInfo.title.string}</span><span class="san-text">&nbsp;-&nbsp;</span><span class="${vyInfo.author.lang}-text">${vyInfo.author.string}</span></div>');
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