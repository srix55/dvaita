import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:site_builder_dart/page-generators/css/css_gen.dart';
import 'package:site_builder_dart/page-generators/landing/lander_page_gen.dart';
import 'package:site_builder_dart/util/helper.dart';
import 'package:site_builder_dart/util/settings.dart';
import 'package:site_builder_dart/xml-generators/xml_gen.dart';

String publicSiteFolder = p.join('..', '..', '..', 'docs');
main() async {
  Helper helper = Helper();
  helper.checkPresentWorkingDirectory();
  Settings.init();
  await helper.clearOutDocsFolder(publicSiteFolder);
  await helper.copyCSS(publicSiteFolder);
  LanderPageGen.generate(publicSiteFolder);
  CssGen.generate(publicSiteFolder);

  // Generate Sumadhva Vijaya
  Directory(p.join('..', '..', '..', 'docs', 'smv')).createSync();
  XmlGen(xmlFile: p.join('..', '..', '..', 'texts', 'sumadhva-vijaya', 'sumadhva-vijaya.xml'), outputLocation: p.join('..', '..', '..', 'docs', 'smv')).generate();
}
