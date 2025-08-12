// Generates the html page hierarchy
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:site_builder_dart/xml-generators/title_handler_html.dart';
import 'package:site_builder_dart/xml_tag.dart';
import 'package:xml/xml.dart';

class XmlGen {
  final String xmlFile;
  final String outputLocation;

  final StringBuffer _stringBuffer = StringBuffer();
  late String _currentDirectory;
  late final XmlDocument _xml;

  XmlGen({required this.xmlFile, required this.outputLocation});

  void generate() {
    _currentDirectory = outputLocation;
    final file = File(xmlFile);
    _xml = XmlDocument.parse(file.readAsStringSync());
    recursivePrint(_xml.rootElement);
  }

  void recursivePrint(XmlElement element) {
    XmlTag tag = XmlTag.fromTag(element.localName);
    switch(tag) {
      case XmlTag.book:
        TitleHandlerHtml(outputLocation: outputLocation, xml: element).generate();
        break;
      case XmlTag.book_title:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vyakhyana_info:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vyakhyana_id:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vyakhyana_title:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vyakhyana_author:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vyakhyana_lang:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.chapter:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.text_with_heading:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.heading:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.heading_content:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.moola:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.shloka:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.anvaya:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vyakhyana:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.p:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.s:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.quick_meaning:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.ps:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.ps_ref:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.meanings_section:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.meaning_word:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.grammar_section:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.grammar_point:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.shabda_roopa:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vibhakti:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.vachana:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.kriya_roopa:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.purusha:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.meaning_point:
        // TODO: Handle this case.
        throw UnimplementedError();
      case XmlTag.meaning:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    print('name-local: ${element.localName}, attributes: ${element.attributes}');
    for (XmlElement e in element.childElements)
      recursivePrint(e);
  }
}