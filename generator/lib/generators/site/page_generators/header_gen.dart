class HeaderGen {
  final int folderLevel;

  HeaderGen({required this.folderLevel});

  String generate() {
    String fullIndexPath = '${'../' * folderLevel}index.html';
    String themeDropdown = _getThemesDropdown();
    return '''
  <header>
    <a href="$fullIndexPath">मुख्यपुटः</a>
    <span class="theme-button" id="theme-button"><svg xmlns="http://www.w3.org/2000/svg" height="23px" viewBox="0 -960 960 960" width="23px"><path d="M480-80q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 32.5-156t88-127Q256-817 330-848.5T488-880q80 0 151 27.5t124.5 76q53.5 48.5 85 115T880-518q0 115-70 176.5T640-280h-74q-9 0-12.5 5t-3.5 11q0 12 15 34.5t15 51.5q0 50-27.5 74T480-80ZM260-440q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17Zm120-160q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17Zm200 0q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17Zm120 160q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17Z"/></svg></span>
    <span class="theme-button" id="mode-button"><svg xmlns="http://www.w3.org/2000/svg" height="23px" viewBox="0 -960 960 960" width="23px"><path d="M480.28-96Q401-96 331-126t-122.5-82.5Q156-261 126-330.96t-30-149.5Q96-560 126-629.5q30-69.5 82.5-122T330.96-834q69.96-30 149.5-30t149.04 30q69.5 30 122 82.5T834-629.28q30 69.73 30 149Q864-401 834-331t-82.5 122.5Q699-156 629.28-126q-69.73 30-149 30ZM516-170q117-14 196.5-101.72T792-480q0-120.56-79.5-208.28T516-790v620Z"/></svg></span>
  </header>
    ''';
  }

  String _getThemesDropdown() {
    return '''
<div class="pure-menu pure-menu-horizontal">
  <ul class="pure-menu-list">
    <li class="pure-menu-item pure-menu-has-children pure-menu-allow-hover">
      <a href="#" class="pure-menu-link">Themes</a>
      <ul class="pure-menu-children">
        <li class="pure-menu-item">
          <div class="theme-circle theme1"></div>
        </li>
        <li class="pure-menu-item">
          <div class="theme-circle theme2"></div>
        </li>
        <li class="pure-menu-item">
          <div class="theme-circle theme3"></div>
        </li>
      </ul>
    </li>
  </ul>
</div>        
    ''';
  }
}