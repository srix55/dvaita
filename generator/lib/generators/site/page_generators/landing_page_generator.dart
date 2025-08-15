// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:generator/generators/site/page_generators/footer_gen.dart';
import 'package:generator/generators/site/util/constants.dart';
import 'package:generator/models/string_with_lang.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:generator/util/settings.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

import 'head_gen.dart';
import 'header_gen.dart';

class LandingPageGenerator {
  void generate() {
    String headSection = HeadGen(folderLevel: 0, cssFileName: Constants.cssFileName, jsFileName: Constants.jsFileName, fontUrl: Settings.font.getGoogleFontFetchURL(), pageTitle: Constants.siteTitle.string).generate();
    Map<String, StringWithLang> bookIdNameMap = _getBooks();
    String bookLinks = '';
    bool first = true;
    for (String key in bookIdNameMap.keys) {
      bookLinks = '$bookLinks${first ? '' : '\n'}<a class="book-link" href="texts/$key/$key.html">${bookIdNameMap[key]!.string}</a>';
      first = false;
    }

    String htmlFinal = '''
<!-- ${Constants.autoGenComment} -->    
<!doctype html>
<html lang="sa">
$headSection
<body>
  ${HeaderGen(folderLevel: 0).generate()}
  <div class="landing-title">द्वैतग्रन्थाः</div>

  <main class="content">
    $bookLinks
  </main>

${FooterGen().generate()}
</body>
</html>
''';
    final indexFile = File(p.join(Settings.config.htmlOutputDirectory, 'index.html'));
    indexFile.writeAsStringSync(htmlFinal, encoding: utf8);
  }

  Map<String, StringWithLang> _getBooks() {
    final rootDir = Directory(Settings.config.textsDirectory);
    Map<String, StringWithLang> map = HashMap();

    // Traverse all files and directories inside, recursively
    for (var entity in rootDir.listSync(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.toLowerCase().endsWith('.xml')) {
        final file = File(entity.path);
        var xml = XmlDocument.parse(file.readAsStringSync());
        for (XmlElement xmlElement in xml.childElements) {
          if (xmlElement.localName == XmlTag.book.tag) {
            String? bookId = xmlElement.getAttribute(Attribute.id.name);
            XmlElement bookTitle = xmlElement.childElements.singleWhere((element) => element.localName == XmlTag.book_title.tag);
            String? lang = bookTitle.getAttribute(Attribute.lang.name);
            String? bookName = bookTitle.innerText;
            if (bookId == null || bookId.isEmpty || lang == null || lang.isEmpty || bookName.isEmpty)
              throw Exception('Invalid book info. BookId: $bookId, bookName: $bookName, titleLang: $lang');
            map[bookId] = StringWithLang(string: bookName, lang: lang);
            break;
          }
        }
      }
    }
    return map;
  }
}