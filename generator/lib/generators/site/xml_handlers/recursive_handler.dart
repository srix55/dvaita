// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:generator/generators/site/xml_handlers/moola_xml_handler.dart';
import 'package:generator/models/string_with_lang.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:xml/xml.dart';

import '../../../models/book_info.dart';
import 'book_index_xml_handler.dart';
import 'chapter_index_xml_handler.dart';

class RecursiveHandler {
  final Set<XmlTag> deniedTags;
  final Set<XmlTag> skipTags;
  final XmlElement xmlElement;
  final StringBuffer buff;
  final BookInfo bookInfo;

  RecursiveHandler({required this.deniedTags, required this.xmlElement, required this.buff,
    required this.bookInfo, required this.skipTags});

  void handle({bool childrenOnly = false}) {
    if (childrenOnly) {
      for (XmlElement element in xmlElement.childElements)
        _recursiveHandler(element);
    } else _recursiveHandler(xmlElement);
  }

  void _recursiveHandler(XmlElement xml) {
    XmlTag tag = XmlTag.fromTag(xml.localName);
    if (deniedTags.contains(tag))
      throw Exception('$RecursiveHandler: The \'${tag.tag}\' element cannot be '
          'in \'${xmlElement.localName}\' element.');
    if (skipTags.contains(tag)) return;
    switch(tag) {
      case XmlTag.book:
        BookIndexXmlHandler(bookXml: xml, bookInfo: bookInfo).handle();
        for (XmlElement element in xml.childElements)
          _recursiveHandler(element);
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
        ChapterIndexXmlHandler(chapterXml: xml, bookInfo: bookInfo).handle();
        for (XmlElement element in xml.childElements) {
          if (element.localName == XmlTag.moola.tag) {
            buff.clear(); // New file per moola
            _recursiveHandler(element);
          }
        }
        break;
      case XmlTag.text_with_heading:
        if (xml.previousElementSibling != null)
          buff.writeln('<hr>');
        for (XmlElement x in xml.childElements)
          _recursiveHandler(x);
        String? nextSibling = xml.nextElementSibling?.localName;
        if (nextSibling != null && (nextSibling == XmlTag.text_with_heading.tag || nextSibling == XmlTag.heading.tag))
          buff.writeln('<hr>');
        break;
      case XmlTag.heading:
        // All headings other than chapter-title are secondary headings
        // String headingLevel = xml.getAttribute(Attribute.level.tag)!;
        String lang = xml.getAttribute(Attribute.lang.tag)!;
        String headingText = xml.innerText;
        if (xml.childElements.isEmpty)
          buff.writeln('<div class="$lang-secondary-heading">$headingText</div>');
        else {
          buff.write('<div class="$lang-secondary-heading">');
          _handleNesting(xml);
          buff.write('</div>');
        }
        break;
      case XmlTag.heading_content:
        String lang = xml.getAttribute(Attribute.lang.tag)!;
        if (xml.childElements.isEmpty) {
          buff.writeln('<div class="$lang-text extra-line-height">${xml.innerText}</div>');
        } else {
          buff.write('<div class="$lang-text extra-line-height">');
          _handleNesting(xml);
          buff.write('</div>');
        }
        if (xml.nextElementSibling != null)
          buff.writeln('<hr>');
        break;
      case XmlTag.moola:
        MoolaXmlHandler(moolaXml: xml, bookInfo: bookInfo).handle();
        break;
      case XmlTag.shloka:
        String? alankara = xml.getAttribute(Attribute.alankara.tag);
        String? vruttam = xml.getAttribute(Attribute.vruttam.tag);
        buff.write('<div class="san-shloka shloka">');
        _handleNesting(xml);
        buff.write('</div>');
        break;
      case XmlTag.shloka_pada:
        buff.writeln('<div>${xml.innerText}</div>');
        break;
      case XmlTag.gadya:
      case XmlTag.anvaya:
        buff.writeln('<hr style="opacity: 0;"><div class="san-meta-heading meta-heading">अन्वयः</div>');
        String lang = xml.getAttribute(Attribute.lang.tag)!;
        if (xml.childElements.isEmpty) {
          buff.writeln('<div class="$lang-text anvaya extra-line-height">${xml.innerText}</div>');
        } else {
          buff.write('<div class="$lang-text extra-line-height">');
          _handleNesting(xml);
          buff.write('</div>');
        }
        break;
      case XmlTag.vyakhyana:
        String vyId = xml.getAttribute(Attribute.ref_id.tag)!;
        String lang = xml.getAttribute(Attribute.lang.tag) ?? 'san';
        XmlElement? previousSibling = xml.previousElementSibling;
        if (previousSibling?.localName == XmlTag.text_with_heading.tag || previousSibling?.localName == XmlTag.anvaya.tag || previousSibling?.localName == XmlTag.vyakhyana.tag)
          buff.writeln('<hr>');
        buff.writeln('<div class="san-meta-heading meta-heading">व्याख्यानं - ${bookInfo.vyakhyanaIdToAuthorNameMap[vyId]!.string}</div>');
        if (xml.childElements.isEmpty) {
          buff.writeln('<div class="$lang-text text extra-line-height">${xml.innerText}</div>');
        } else {
          buff.write('<div class="$lang-text text extra-line-height">');
          _handleNesting(xml);
          buff.write('</div>');
        }
        break;
      case XmlTag.p:
        String? lang = xml.getAttribute(Attribute.lang.tag)!;
        if (xml.childElements.isEmpty) {
          buff.writeln('<p class="$lang-text text">${xml.innerText}</p>');
        } else {
          buff.write('<p class="$lang-text text">');
          _handleNesting(xml);
          buff.write('</p>');
        }
        break;
      case XmlTag.s:
        bool em = xml.attributes.any((att) => att.localName == Attribute.em.tag);
        String? id = xml.getAttribute(Attribute.id.tag);
        String? lang = xml.getAttribute(Attribute.lang.tag);
        String? qm = xml.getAttribute(Attribute.qm.tag);
        List<StringWithLang> quickMeanings = [];
        if (qm != null) {
          List<String> words = qm.split('_');
          for (String w in words) {
            if (w.contains('#')) { // Has language too, else use default sanskrit
              List<String> wordAndLanguage = w.split('#');
              String lang = wordAndLanguage[0];
              String word = wordAndLanguage[1];
              quickMeanings.add(StringWithLang(string: word, lang: lang));
            } else {
              quickMeanings.add(StringWithLang(string: w, lang: 'san'));
            }
          }
        }
        List<String> features = xml.getAttribute(Attribute.feat.tag)?.split(',') ?? [];
        bool isMeaning = false, isGrammar = false, isPs = false;
        for (String feat in features) {
          switch(feat) {
            case 'm': isMeaning = true; break;
            case 'g': isGrammar = true; break;
            case 'ps': isPs = true; break;
          }
        }
        String? segClass;
        // Check if this segment was in a heading. To retain the heading class with lang change, for which it was likely segmented
        if (xml.parentElement?.localName == XmlTag.heading.tag) segClass = lang != null ? '$lang-secondary-heading' : '';
        if (xml.childElements.isEmpty) {
          if (em == false && id == null && lang == null)
            buff.write('<span class="segment">${xml.innerText}</span>');
          else {
            if (quickMeanings.isNotEmpty) {
              if (segClass != null) segClass = '$segClass dotted-underline';
              else segClass = 'dotted-underline';
            }
            buff.write('<span${id != null ? ' id="$id"' : ''}${segClass != null ? ' class="$segClass"':''}>${xml.innerText}</span>');
          }
        } else {
          if (em == false && id == null && lang == null)
            buff.write('<span>');
          else {
            if (quickMeanings.isNotEmpty) {
              if (segClass != null) segClass = '$segClass dotted-underline';
              else segClass = 'dotted-underline';
            }
            buff.write('<span${id != null ? ' id="$id"' : ''}${segClass != null ? ' class="$segClass"':''}>');
          }
          _handleNesting(xml);
          buff.write('</span>');
        }
        if (quickMeanings.isNotEmpty) buff.write('<span style="position: relative; display: inline-block;">');
        for (StringWithLang quickMeaning in quickMeanings) {
          buff.write('<span class="${quickMeaning.lang}-inline inline">${quickMeaning.string}</span>');
        }
        if (quickMeanings.isNotEmpty) buff.write('</span>');
        break;
      case XmlTag.ps:
      case XmlTag.ps_ref:
      case XmlTag.meanings_section:
      case XmlTag.meaning_point:
      case XmlTag.meaning_word:
      case XmlTag.meaning:
      case XmlTag.grammar_section:
      case XmlTag.grammar_point:
      case XmlTag.shabda_roopa:
      case XmlTag.vibhakti:
      case XmlTag.vachana:
      case XmlTag.kriya_roopa:
      case XmlTag.purusha:
    }
  }

  void _handleNesting(XmlElement xml) {
    for (XmlNode x in xml.children) {
      if (x.nodeType == XmlNodeType.TEXT)
        buff.write((x as XmlText).value);
      else if (x.nodeType == XmlNodeType.ELEMENT)
        _recursiveHandler(x as XmlElement);
    }
  }
}