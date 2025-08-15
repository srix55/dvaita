// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:generator/generators/site/xml_handlers/book_index_xml_handler.dart';
import 'package:generator/generators/site/xml_handlers/chapter_xml_handler.dart';
import 'package:generator/models/book_info.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:xml/xml.dart';

class XmlHandler {
  final XmlDocument xml;

  late final BookInfo bookInfo;
  
  XmlHandler({required this.xml}) {
    XmlElement bookXml = xml.findAllElements(XmlTag.book.tag).first;
    if (bookXml == null) {
      throw Exception('The xmlDocument does not seem to have a book element. Please verify that it is a valid text-xml and it conforms to the specs as defined.');
    }
    bookInfo = BookInfo.xmlBook(bookXml);
  }

  void generate() {
    XmlElement? bookXml = xml.findAllElements(XmlTag.book.tag).first;
    if (bookXml.localName != XmlTag.book.tag) {
      throw Exception('The xmlDocument does not seem to have a book element. Please verify that it is a valid text-xml and it conforms to the specs as defined.');
    }

    BookIndexXmlHandler(bookXml: bookXml, bookInfo: bookInfo).handle();
    for (XmlElement element in bookXml.childElements) {
      XmlTag tag = XmlTag.fromTag(element.localName);
      switch(tag) {
        case XmlTag.book:
        case XmlTag.book_title:
        case XmlTag.book_author:
        case XmlTag.vyakhyana_info:
        case XmlTag.vyakhyana_id:
        case XmlTag.vyakhyana_title:
        case XmlTag.vyakhyana_author:
        case XmlTag.vyakhyana_lang:
        // Handled in book tag
          break;
        case XmlTag.chapter:
          ChapterXmlHandler(chapterXml: element, bookInfo: bookInfo).handle();
          break;
        case XmlTag.text_with_heading:
        case XmlTag.heading:
        case XmlTag.heading_content:
        case XmlTag.moola:
        case XmlTag.shloka:
        case XmlTag.gadya:
        case XmlTag.anvaya:
        case XmlTag.vyakhyana:
        case XmlTag.p:
        case XmlTag.s:
        case XmlTag.quick_meaning:
        case XmlTag.ps:
        case XmlTag.ps_ref:
        case XmlTag.meanings_section:
        case XmlTag.meaning_point:
        case XmlTag.meaning_word:
        case XmlTag.meaning:
        case XmlTag.grammar_section:
        case XmlTag.grammar_point:
        case XmlTag.shabda_roopa:
        case XmlTag.vibhakti:
        case XmlTag.vachana:
        case XmlTag.kriya_roopa:
        case XmlTag.purusha:
          throw Exception('$XmlHandler: The xml element of name \'${element.localName}\' '
              'should probably be under a chapter (\'${XmlTag.chapter.tag}\')');
      }
    }
  }
}