class StringWithLang {
  final String string;
  final String lang;

  StringWithLang({required this.string, required this.lang});

  @override
  String toString() {
    return 'StringWithLang{string: $string, lang: $lang}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringWithLang &&
          runtimeType == other.runtimeType &&
          string == other.string &&
          lang == other.lang;

  @override
  int get hashCode => Object.hash(string, lang);
  // 3 letter code


}