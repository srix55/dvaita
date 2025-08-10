import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class Helper {
  void checkPresentWorkingDirectory() {
    final current = Directory.current;
    final sep = Platform.pathSeparator;
    if (!current.path.endsWith('dvaita${sep}the-website${sep}generator${sep}site_builder_dart')) {
      print("Make sure that the present working directory is 'dvaita${sep}the-website${sep}generator${sep}site_builder_dart' to run the builder dart script.");
      print("The present working directory is ${current.path}");
      exit(0);
    }
  }

  Future<void> copyCSS(String publicSiteFolder) async {
    final sourcePath = p.join('lib', 'main.css');
    final destinationDir = Directory(publicSiteFolder);

    // Ensure destination directory exists
    if (!destinationDir.existsSync()) {
      print("Destination directory 'docs' does not exist");
      exit(1);
    }

    final destinationPath = p.join(destinationDir.path, 'main.css');

    try {
      await File(sourcePath).copy(destinationPath);
      print('Copied $sourcePath → $destinationPath');
    } catch (e) {
      print('Error copying file: $e');
      exit(1);
    }
  }

  static dynamic getYamlAsString(String filePath) {
    return loadYaml(File(filePath).readAsStringSync());
  }

  Future<void> clearOutDocsFolder(String publicSiteFolder) async {
    final dir = Directory(publicSiteFolder);

    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: false)) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (e) {
          print('Error deleting ${entity.path}: $e');
          exit(1);
        }
      }
      print('Cleared contents of ${dir.path}');
    } else {
      print('${dir.path} does not exist.');
      exit(0);
    }
  }
}