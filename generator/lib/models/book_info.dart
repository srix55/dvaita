// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:collection';

import 'package:generator/models/string_with_lang.dart';
import 'package:generator/models/vyakhyana_info.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:xml/xml.dart';

import 'book_type.dart';

class BookInfo {
  late StringWithLang bookTitle;
  late final List<StringWithLang> bookAuthors = [];
  late BookType bookType;
  late String bookId;
  final List<VyakhyanaInfo> vyakhyanaInfoList = [];
  final Map<String, StringWithLang> vyakhyanaIdToAuthorNameMap = HashMap();

  BookInfo.xmlBook(XmlElement bookXml) {
    if (bookXml.localName != XmlTag.book.tag)
      throw Exception('$BookInfo: bookXml is not the book-element');

    _getBookId(bookXml);
    _getBookType(bookXml);
    _getBookTitle(bookXml);
    _getBookAuthors(bookXml);
    _getVyakhyanaList(bookXml);
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
      vyakhyanaInfoList.add(vi);
      vyakhyanaIdToAuthorNameMap[vi.id] = vi.author;
    }
  }

  void _getBookTitle(XmlElement element) {
    XmlElement? bookTitleElement = element.getElement(XmlTag.book_title.tag);
    if (bookTitleElement == null) {
      throw Exception('The xmlDocument does not seem to have a book element. Please verify that it is a valid text-xml and it conforms to the specs as defined.');
    }
    String? language = bookTitleElement.getAttribute(Attribute.lang.tag);
    if (language == null) throw Exception('The book-title is missing the language attribute');
    bookTitle = StringWithLang(string: bookTitleElement.innerText, lang: language);
  }

  void _getBookAuthors(XmlElement element) {
    List<XmlElement> authorElements = element.findAllElements(XmlTag.book_author.tag).toList();
    for (XmlElement bookAuthorElement in authorElements) {
      String? language = bookAuthorElement.getAttribute(Attribute.lang.tag);
      if (language == null) throw Exception(
          'The book-author is missing the language attribute');
      bookAuthors.add(StringWithLang(string: bookAuthorElement.innerText, lang: language));
    }
  }

  void _getBookId(XmlElement element) {
    String? bId = element.getAttribute(Attribute.id.tag);
    if (bId == null) throw Exception('The book is missing the id attribute. ${XmlTag.book.tag} should have the ${Attribute.id.tag} attribute');
    bookId = bId;
  }

  void _getBookType(XmlElement element) {
    String? type = element.getAttribute(Attribute.book_type.tag);
    if (type == null) throw Exception("The book doesn't seem to have the mandatory '${Attribute.book_type.tag}'. It can be one of ${BookType.values}");
    bookType = BookType.values.byName(type);
  }
}