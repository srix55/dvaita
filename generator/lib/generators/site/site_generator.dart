import 'package:generator/generators/site/page_generators/css_gen.dart';
import 'package:generator/generators/site/page_generators/landing_page_generator.dart';

class SiteGenerator {
  static void generate() {
    LandingPageGenerator().generate();
    CssGen().generate();
  }
}