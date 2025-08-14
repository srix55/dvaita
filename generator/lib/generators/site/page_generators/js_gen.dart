import 'dart:convert';
import 'dart:io';

import 'package:generator/generators/site/util/constants.dart';
import 'package:generator/util/settings.dart';
import 'package:path/path.dart' as p;

class JsGen {
  void generate() {
    final jsFile = File(p.join(Settings.config.htmlOutputDirectory, Constants.jsFileName));
    final jsFileText = _getText();
    jsFile.writeAsStringSync(jsFileText, encoding: utf8);
  }

  String _getText() {
    String themesList = _getThemesList();
    return '''
// List of themes you want to cycle through
const themes = $themesList;

// Apply theme & mode to the <html> element
function setTheme(theme, mode) {
  document.documentElement.setAttribute('data-theme', theme);
  document.documentElement.setAttribute('data-mode', mode);

  // Save preferences
  localStorage.setItem('theme', theme);
  localStorage.setItem('mode', mode);
}

// Detect system dark mode preference
function getSystemMode() {
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

// Load saved settings or fall back to defaults
function initTheme() {
  const savedTheme = localStorage.getItem('theme');
  const savedMode = localStorage.getItem('mode');

  if (savedTheme && savedMode) {
    setTheme(savedTheme, savedMode);
  } else {
    setTheme('theme1', getSystemMode());
  }
}

// Toggle between light and dark mode (for current theme)
function toggleMode() {
  const currentMode = document.documentElement.getAttribute('data-mode');
  const newMode = currentMode === 'light' ? 'dark' : 'light';
  setTheme(document.documentElement.getAttribute('data-theme'), newMode);
}

// Change to a different theme, keeping the current mode
function changeTheme(newTheme) {
  const currentMode = document.documentElement.getAttribute('data-mode');
  setTheme(newTheme, currentMode);
}

// Cycle through themes
function cycleTheme() {
  const currentTheme = document.documentElement.getAttribute('data-theme');
  const currentIndex = themes.indexOf(currentTheme);
  const nextIndex = (currentIndex + 1) % themes.length;
  changeTheme(themes[nextIndex]);
}

document.documentElement.classList.add('no-transitions');

// Run at page load
document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  
  // Allow transitions after a tiny delay
  requestAnimationFrame(() => {
    document.documentElement.classList.remove('no-transitions');
  });

  // Theme cycle button
  const themeButton = document.getElementById('theme-button');
  if (themeButton) {
    themeButton.addEventListener('click', cycleTheme);
  }

  // Light/Dark toggle button
  const modeButton = document.getElementById('mode-button');
  if (modeButton) {
    modeButton.addEventListener('click', toggleMode);
  }
});

// Expose functions globally (optional)
window.setTheme = setTheme;
window.toggleMode = toggleMode;
window.changeTheme = changeTheme;
window.cycleTheme = cycleTheme;
    ''';
  }

  String _getThemesList() {
    StringBuffer themesList = StringBuffer();
    themesList.write('[');
    for (int i=0; i<Settings.allColorThemes.length; i++) {
      String themeId = Settings.allColorThemes[i].id;
      if (i!=0) themesList.write(' ');
      themesList.write("'$themeId'");
      if (i != (Settings.allColorThemes.length - 1)) themesList.write(',');
    }
    themesList.write(']');
    return themesList.toString();
  }
}