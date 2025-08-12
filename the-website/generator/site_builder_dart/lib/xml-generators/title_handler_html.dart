import 'dart:io';

import 'package:xml/xml.dart';

class TitleHandlerHtml {
  final String outputLocation;
  final XmlElement xml;

  TitleHandlerHtml({required this.outputLocation, required this.xml});

  void generate() {
    String htmlFileName = outputLocation.split(Platform.pathSeparator).last;
  }
}