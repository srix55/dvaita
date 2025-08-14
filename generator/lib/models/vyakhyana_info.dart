import 'package:generator/models/string_with_lang.dart';

class VyakhyanaInfo {
  final String id;
  final StringWithLang title;
  final StringWithLang author;
  final String lang;

  VyakhyanaInfo({required this.id, required this.title, required this.author, required this.lang});

  @override
  String toString() {
    return 'VyakhyanaInfo{id: $id, title: $title, author: $author, lang: $lang}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VyakhyanaInfo && runtimeType == other.runtimeType &&
              id == other.id && title == other.title &&
              author == other.author && lang == other.lang;

  @override
  int get hashCode => Object.hash(id, title, author, lang);


}