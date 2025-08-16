// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:generator/generators/site/page_generators/page_gen.dart';
import 'package:generator/generators/site/xml_handlers/recursive_handler.dart';
import 'package:generator/models/book_info.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:generator/util/settings.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

import '../../../models/string_with_lang.dart';

class MoolaXmlHandler {
  final XmlElement moolaXml;
  late final BookInfo bookInfo;
  late final StringWithLang _moolaId;
  
  final StringBuffer _buff = StringBuffer();

  MoolaXmlHandler({required this.moolaXml, required this.bookInfo}) {
    if (moolaXml.localName != XmlTag.moola.tag)
      throw Exception('$MoolaXmlHandler: XmlElement is supposed to be a \'${XmlTag.moola.tag}\' element. But, it is \'${moolaXml.localName}\'');
    String id = moolaXml.getAttribute(Attribute.id.tag)!;
    String lang = moolaXml.getAttribute(Attribute.lang.tag)!;
    _moolaId = StringWithLang(string: id, lang: lang);
  }

  void handle() {
    _handlePreviousNextButtons();
    Set<XmlTag> deniedTags = {XmlTag.book, XmlTag.book_title, XmlTag.book_author,
      XmlTag.vyakhyana_info, XmlTag.vyakhyana_id, XmlTag.vyakhyana_title,
      XmlTag.vyakhyana_author, XmlTag.vyakhyana_lang, XmlTag.chapter, XmlTag.moola};
    RecursiveHandler(deniedTags: deniedTags, bookInfo: bookInfo, skipTags: {}, buff: _buff, xmlElement: moolaXml).handle(childrenOnly: true);
    String chapterNumber = moolaXml.parentElement!.getAttribute(Attribute.number.tag)!;
    PageGen(pageTitle: bookInfo.bookTitle.string, folderLevel: 3, fileName: '${_moolaId.string}.html', htmlContent: _buff.toString(), outputDir: p.join(Settings.config.htmlOutputDirectory, 'texts', bookInfo.bookId, 'c$chapterNumber')).generate();
  }

  void _handlePreviousNextButtons() {
    String? previousMoolaId, nextMoolaId;
    if (moolaXml.previousElementSibling?.localName == XmlTag.moola.tag)
      previousMoolaId = moolaXml.previousElementSibling!.getAttribute(Attribute.id.tag)!;
    else
      previousMoolaId = 'c${moolaXml.parentElement!.getAttribute(Attribute.number.tag)}';
    if (moolaXml.nextElementSibling?.localName == XmlTag.moola.tag)
      nextMoolaId = moolaXml.nextElementSibling!.getAttribute(Attribute.id.tag)!;
    if (previousMoolaId != null || nextMoolaId != null) {
      _buff.write('<div>');
      if (previousMoolaId != null) _buff.write('<a href="$previousMoolaId.html" class="previous san">&lt;&nbsp;&nbsp;पूर्वम्</a>');
      if (nextMoolaId != null) _buff.write('<a href="$nextMoolaId.html" class="next san">अग्रिमम्&nbsp;&nbsp;&gt;</a>');
      _buff.write('</div>');
    }
  }
}