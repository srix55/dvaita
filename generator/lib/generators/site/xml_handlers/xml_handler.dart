// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:collection';

import 'package:generator/generators/site/page_generators/book_index_gen.dart';
import 'package:generator/models/book_type.dart';
import 'package:generator/models/string_with_lang.dart';
import 'package:generator/models/vyakhyana_info.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:xml/xml.dart';

class XmlHandler {
  final XmlDocument xml;

  late StringWithLang _bookTitle;
  late List<StringWithLang> _bookAuthors = [];
  late BookType _bookType;
  late String _bookId;
  final List<VyakhyanaInfo> _vyakhyanaInfoList = [];
  final Map<String, StringWithLang> _vyakhyanaIdToAuthorNameMap = HashMap();
  
  XmlHandler({required this.xml}) {
    XmlElement element = xml.findAllElements(XmlTag.book.tag).first;
    if (element == null) {
      throw Exception('The xmlDocument does not seem to have a book element. Please verify that it is a valid text-xml and it conforms to the specs as defined.');
    }
    _getBookId(element);
    _getBookType(element);
    _getBookTitle(element);
    _getBookAuthors(element);
    _getVyakhyanaList(element);
  }

  void _getVyakhyanaList(XmlElement element) {
    List<XmlElement> vyakhyanaInfoElements = element.findAllElements(XmlTag.vyakhyana_info.tag).toList();
    for (XmlElement vyInfoElement in vyakhyanaInfoElements) {
      String vyId = vyInfoElement.getElement(XmlTag.vyakhyana_id.tag)!.innerText;
      String vyAuthor = vyInfoElement.getElement(XmlTag.vyakhyana_author.tag)!.innerText;
      String vyAuthorLang = vyInfoElement.getElement(XmlTag.vyakhyana_author.tag)!.getAttribute(Attribute.lang.tag)!;
      String vyTitle = vyInfoElement.getElement(XmlTag.vyakhyana_title.tag)!.innerText;
      String vyTitleLang = vyInfoElement.getElement(XmlTag.vyakhyana_title.tag)!.getAttribute(Attribute.lang.tag)!;
      String vyLang = vyInfoElement.getElement(XmlTag.vyakhyana_lang.tag)!.innerText;
      VyakhyanaInfo vi = VyakhyanaInfo(id: vyId, title: StringWithLang(string: vyTitle, lang: vyTitleLang), author: StringWithLang(string: vyAuthor, lang: vyAuthorLang), lang: vyLang);
      _vyakhyanaInfoList.add(vi);
      _vyakhyanaIdToAuthorNameMap[vi.id] = vi.author;
    }
  }

  void _getBookTitle(XmlElement element) {
    XmlElement? bookTitleElement = element.getElement(XmlTag.book_title.tag);
    if (bookTitleElement == null) {
      throw Exception('The xmlDocument does not seem to have a book element. Please verify that it is a valid text-xml and it conforms to the specs as defined.');
    }
    String? language = bookTitleElement.getAttribute(Attribute.lang.tag);
    if (language == null) throw Exception('The book-title is missing the language attribute');
    _bookTitle = StringWithLang(string: bookTitleElement.innerText, lang: language);
  }  
  
  void _getBookAuthors(XmlElement element) {
    List<XmlElement> authorElements = element.findAllElements(XmlTag.book_author.tag).toList();
    for (XmlElement bookAuthorElement in authorElements) {
      String? language = bookAuthorElement.getAttribute(Attribute.lang.tag);
      if (language == null) throw Exception(
          'The book-author is missing the language attribute');
      _bookAuthors.add(StringWithLang(string: bookAuthorElement.innerText, lang: language));
    }
  }

  void _getBookId(XmlElement element) {
    String? bookId = element.getAttribute(Attribute.id.tag);
    if (bookId == null) throw Exception('The book is missing the id attribute. ${XmlTag.book.tag} should have the ${Attribute.id.tag} attribute');
    _bookId = bookId;
  }

  void _getBookType(XmlElement element) {
    String? type = element.getAttribute(Attribute.book_type.tag);
    if (type == null) throw Exception("The book doesn't seem to have the mandatory '${Attribute.book_type.tag}'. It can be one of ${BookType.values}");
    _bookType = BookType.values.byName(type);
  }

  void generate() {
    XmlElement? element = xml.findAllElements(XmlTag.book.tag).first;
    if (element == null) {
      throw Exception('The xmlDocument does not seem to have a book element. Please verify that it is a valid text-xml and it conforms to the specs as defined.');
    }
    _recursiveTagHandler(element);
  }

  List<BookIndexChapterInfo> _getChapters(XmlElement book) {
    List<BookIndexChapterInfo> infoList = [];
    List<XmlElement> chapterElements = book.findAllElements(XmlTag.chapter.tag).toList();
    for (XmlElement chapter in chapterElements) {
      String chapterName = chapter.getAttribute(Attribute.name.tag)!;
      String chapterNumber = chapter.getAttribute(Attribute.number.tag)!;
      String lang = chapter.getAttribute(Attribute.lang.tag)!;
      BookIndexChapterInfo info = BookIndexChapterInfo(chapter: StringWithLang(string: chapterName, lang: lang), chapterId: chapterNumber);
      infoList.add(info);
    }
    return infoList;
  }

  void _recursiveTagHandler(XmlElement element) {
    XmlTag tag = XmlTag.fromTag(element.localName);
    switch(tag) {
      case XmlTag.book:
        BookIndexGen(bookTitle: _bookTitle, authors: _bookAuthors, vyakhyanas: _vyakhyanaInfoList, bookId: _bookId, bookType: _bookType, chapters: _getChapters(element)).generate();
        break;
      case XmlTag.book_title:
      case XmlTag.book_author:
      case XmlTag.vyakhyana_info:
      case XmlTag.vyakhyana_id:
      case XmlTag.vyakhyana_title:
      case XmlTag.vyakhyana_author:
      case XmlTag.vyakhyana_lang:
        // Handled in book tag
        break;
      case XmlTag.chapter:
        break;
      case XmlTag.text_with_heading:
        break;
      case XmlTag.heading:
        break;
      case XmlTag.heading_content:
        break;
      case XmlTag.moola:
        break;
      case XmlTag.shloka:
        break;
      case XmlTag.gadya:
        break;
      case XmlTag.anvaya:
        break;
      case XmlTag.vyakhyana:
        break;
      case XmlTag.p:
        break;
      case XmlTag.s:
        break;
      case XmlTag.quick_meaning:
        break;
      case XmlTag.ps:
        break;
      case XmlTag.ps_ref:
        break;
      case XmlTag.meanings_section:
        break;
      case XmlTag.meaning_point:
        break;
      case XmlTag.meaning_word:
        break;
      case XmlTag.meaning:
        break;
      case XmlTag.grammar_section:
        break;
      case XmlTag.grammar_point:
        break;
      case XmlTag.shabda_roopa:
        break;
      case XmlTag.vibhakti:
        break;
      case XmlTag.vachana:
        break;
      case XmlTag.kriya_roopa:
        break;
      case XmlTag.purusha:
        break;
    }

    for (XmlElement e in element.childElements)
      _recursiveTagHandler(e);
  }
}