// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:generator/generators/site/xml_handlers/book_index_xml_handler.dart';
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
    XmlElement? element = xml.findAllElements(XmlTag.book.tag).first;
    if (element == null) {
      throw Exception('The xmlDocument does not seem to have a book element. Please verify that it is a valid text-xml and it conforms to the specs as defined.');
    }
    _recursiveTagHandler(element);
  }

  void _recursiveTagHandler(XmlElement element) {
    XmlTag tag = XmlTag.fromTag(element.localName);
    switch(tag) {
      case XmlTag.book:
        BookIndexXmlHandler(bookXml: element, bookInfo: bookInfo).handle();
        break;
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
        break;
      case XmlTag.text_with_heading:
        break;
      case XmlTag.heading:
        break;
      case XmlTag.heading_content:
        break;
      case XmlTag.moola:
        break;
      case XmlTag.shloka:
        break;
      case XmlTag.gadya:
        break;
      case XmlTag.anvaya:
        break;
      case XmlTag.vyakhyana:
        break;
      case XmlTag.p:
        break;
      case XmlTag.s:
        break;
      case XmlTag.quick_meaning:
        break;
      case XmlTag.ps:
        break;
      case XmlTag.ps_ref:
        break;
      case XmlTag.meanings_section:
        break;
      case XmlTag.meaning_point:
        break;
      case XmlTag.meaning_word:
        break;
      case XmlTag.meaning:
        break;
      case XmlTag.grammar_section:
        break;
      case XmlTag.grammar_point:
        break;
      case XmlTag.shabda_roopa:
        break;
      case XmlTag.vibhakti:
        break;
      case XmlTag.vachana:
        break;
      case XmlTag.kriya_roopa:
        break;
      case XmlTag.purusha:
        break;
    }

    for (XmlElement e in element.childElements)
      _recursiveTagHandler(e);
  }
}