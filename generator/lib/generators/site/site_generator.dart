import 'dart:io';

import 'package:generator/generators/site/page_generators/css_gen.dart';
import 'package:generator/generators/site/page_generators/js_gen.dart';
import 'package:generator/generators/site/page_generators/landing_page_generator.dart';
import 'package:generator/generators/site/xml_handlers/xml_handler.dart';
import 'package:generator/util/settings.dart';
import 'package:xml/xml.dart';

class SiteGenerator {
  static void generate() {
    LandingPageGenerator().generate();
    CssGen().generate();
    JsGen().generate();

    // For each text, generate
    final rootDir = Directory(Settings.config.textsDirectory);
    for (var entity in rootDir.listSync(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.toLowerCase().endsWith('.xml')) {
        final file = File(entity.path);
        var xml = XmlDocument.parse(file.readAsStringSync());
        XmlHandler(xml: xml).generate();
      }
    }
  }
}