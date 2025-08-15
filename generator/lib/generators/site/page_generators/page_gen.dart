// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../util/settings.dart';
import '../util/constants.dart';
import 'footer_gen.dart';
import 'head_gen.dart';
import 'header_gen.dart';

class PageGen {
  final String pageTitle;
  final int folderLevel;
  final String fileName;
  final String outputDir;
  final String htmlContent;

  PageGen({required this.pageTitle, required this.folderLevel, required this.fileName,
    required this.outputDir, required this.htmlContent}) {
    var dir = Directory(outputDir);
    if (!dir.existsSync())
      throw Exception('$PageGen: outputDir "$outputDir" does not exist');
  }

  void generate() {
    final htmlFile = File(p.join(outputDir, fileName));
    String htmlFinal = '''
<!-- ${Constants.autoGenComment} -->    
<!doctype html>
<html lang="sa">
${HeadGen(folderLevel: folderLevel, cssFileName: Constants.cssFileName, jsFileName: Constants.jsFileName, fontUrl: Settings.font.getGoogleFontFetchURL(), pageTitle: pageTitle).generate()}
<body>
${HeaderGen(folderLevel: folderLevel).generate()}

$htmlContent

${FooterGen().generate()}
</body>
</html>
''';
    htmlFile.writeAsStringSync(htmlFinal, encoding: utf8);
  }
}