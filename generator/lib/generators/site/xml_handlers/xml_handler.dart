// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:generator/generators/site/xml_handlers/recursive_handler.dart';
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

    RecursiveHandler(deniedTags: {}, skipTags: {}, bookInfo: bookInfo, buff: StringBuffer(), xmlElement: bookXml).handle();
  }
}