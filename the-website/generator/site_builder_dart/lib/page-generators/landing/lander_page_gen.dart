import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'lander_head_gen.dart';
import 'lander_html_gen.dart';

class LanderPageGen {
  static void generate(String publicSiteFolder) {
    final indexFile = File(p.join(publicSiteFolder, 'index.html'));

    final landerHtmlFile = LanderHtmlGen.get();
    indexFile.writeAsStringSync(landerHtmlFile, encoding: utf8);
    print('Wrote ${indexFile.path}');
  }
}