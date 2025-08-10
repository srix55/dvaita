// Generates the html page hierarchy
import 'dart:io';

import 'package:xml/xml.dart';

class XmlGen {
  final String xmlFile;
  final String outputLocation;

  late final XmlDocument _xml;

  XmlGen({required this.xmlFile, required this.outputLocation});

  void generate() {
    final file = File(xmlFile);
    _xml = XmlDocument.parse(file.readAsStringSync());
  }
}