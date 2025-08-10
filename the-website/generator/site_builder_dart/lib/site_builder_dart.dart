import 'package:path/path.dart' as p;
import 'package:site_builder_dart/page-generators/css/css_gen.dart';
import 'package:site_builder_dart/page-generators/landing/lander_page_gen.dart';
import 'package:site_builder_dart/util/helper.dart';

String publicSiteFolder = p.join('..', '..', '..', 'docs');
main() async {
  Helper helper = Helper();
  helper.checkPresentWorkingDirectory();
  await helper.clearOutDocsFolder(publicSiteFolder);
  await helper.copyCSS(publicSiteFolder);
  LanderPageGen.generate(publicSiteFolder);
  CssGen.generate(publicSiteFolder);
}
