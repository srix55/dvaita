// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:generator/generators/site/page_generators/page_gen.dart';
import 'package:generator/models/book_info.dart';
import 'package:generator/models/book_type.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:generator/util/settings.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

import '../../../models/string_with_lang.dart';
import '../../../models/vyakhyana_info.dart';

class ChapterXmlHandler {
  final XmlElement chapterXml;
  late final BookInfo bookInfo;
  late final String _chapterNum;
  late final StringWithLang _chapterName;
  
  final StringBuffer _buff = StringBuffer();

  ChapterXmlHandler({required this.chapterXml, required this.bookInfo}) {
    if (chapterXml.localName != XmlTag.chapter.tag)
      throw Exception('$ChapterXmlHandler: XmlElement is supposed to be a \'${XmlTag.chapter.tag}\' element. But, it is \'${chapterXml.localName}\'');
    _chapterNum = chapterXml.getAttribute(Attribute.number.tag)!;
    String name = chapterXml.getAttribute(Attribute.name.tag)!;
    String lang = chapterXml.getAttribute(Attribute.lang.tag)!;
    _chapterName = StringWithLang(string: name, lang: lang);
  }

  void handle() {
    final dir = Directory(p.join(Settings.config.htmlOutputDirectory, 'texts', bookInfo.bookId, 'c$_chapterNum'));
    dir.createSync(recursive: true);
    
    _buff.writeln('<div class="chapter-title ${_chapterName.lang}-chapter-title">${_chapterName.string}</div>');
    if (bookInfo.bookType == BookType.kavya) {
      String links = _getShlokaLinks();
      if (links.isNotEmpty)
        _buff.writeln('<div class="shloka-links">$links</div>');
    }
    PageGen(pageTitle: bookInfo.bookTitle.string, folderLevel: 3, fileName: 'c$_chapterNum.html', htmlContent: _buff.toString(), outputDir: p.join(Settings.config.htmlOutputDirectory, 'texts', bookInfo.bookId, 'c$_chapterNum')).generate();
  }

  void _recursiveHandler(XmlElement xml) {
    // TBD
  }

  List<StringWithLang> _getShlokasOfThisChapter() {
    List<StringWithLang> shlokaList = [];
    List<XmlElement> shlokaElements = chapterXml.findAllElements(XmlTag.moola.tag).toList();
    for (XmlElement moola in shlokaElements) {
      String moolaId = moola.getAttribute(Attribute.id.tag)!;
      String moolaIdLang = moola.getAttribute(Attribute.lang.tag)!;
      shlokaList.add(StringWithLang(string: moolaId, lang: moolaIdLang));
    }
    return shlokaList;
  }

  String _getShlokaLinks() {
    List<StringWithLang> shlokas = _getShlokasOfThisChapter();
    String shlokaLinks = '';
    for (int i=0; i<shlokas.length; i++) {
      StringWithLang info = shlokas[i];
      bool first = i==0;
      shlokaLinks = '$shlokaLinks<a href="${info.string}.html" ${first ? '' : 'style="margin-left: 2em;" class="${info.lang}"'}>${info.string}</a>';
    }
    return shlokaLinks;
  }
}