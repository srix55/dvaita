// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:generator/generators/site/site_generator.dart';
import 'package:generator/util/settings.dart';
import 'package:path/path.dart' as p;

main(List<String> args) async {
  // See if settings folder is specified in args
  String settingsFolder;
  if (args.isNotEmpty)
    settingsFolder = args.first;
  else
    settingsFolder = p.join('settings');

  // Make sure the settings folder exists
  var dir = Directory(settingsFolder);
  if (!dir.existsSync())
    throw Exception('Specify settings folder that contains the yamls. Currently no such directory \'$settingsFolder\' exists. Settings folder can also be specified as a command line argument.');

  Settings.init(settingsFolder);

  // Pre-process steps
  _refreshDirectories();

  if (Settings.config.shouldGenerateHtml)
    SiteGenerator.generate();
}

// Clear out the output folders or create them if they don't exist
void _refreshDirectories() {
  if (Settings.config.shouldGenerateHtml) {
    var dir = Directory(Settings.config.htmlOutputDirectory);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    dir.createSync(recursive: true);
    var textsDir = Directory(p.join(Settings.config.htmlOutputDirectory, 'texts'));
    textsDir.createSync();
  }
  
  if (Settings.config.shouldGeneratePdf) {
    var dir = Directory(Settings.config.pdfOutputDirectory);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    dir.createSync(recursive: true);
  }
  
  if (Settings.config.shouldGenerateOdt) {
    var dir = Directory(Settings.config.odtOutputDirectory);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    dir.createSync(recursive: true);
  }
}
