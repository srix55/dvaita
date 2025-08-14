class HeadGen {
  // Determines the relative url of css file
  final int folderLevel;
  final String cssFileName; // Just the name. ex: main.css
  final String jsFileName;
  final String fontUrl;
  final String pageTitle;

  HeadGen({required this.folderLevel, required this.cssFileName, required this.fontUrl, required this.pageTitle, required this.jsFileName});

  String generate() {
    String fullCSSPath = '${'../' * folderLevel}$cssFileName';
    String fullJsPath = '${'../' * folderLevel}$jsFileName';
    return '''
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>$pageTitle</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="$fontUrl" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
  <link rel="stylesheet" href="$fullCSSPath">
  <script src="$fullJsPath" defer></script>
</head>    
    ''';
  }
}