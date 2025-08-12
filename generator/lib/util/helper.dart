import 'dart:io';

import 'package:yaml/yaml.dart';

class Helper {
  static dynamic getYamlAsString(String filePath) {
    return loadYaml(File(filePath).readAsStringSync());
  }
}