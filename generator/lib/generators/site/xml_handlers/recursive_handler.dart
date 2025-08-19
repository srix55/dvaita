// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:generator/generators/site/util/constants.dart';
import 'package:generator/generators/site/xml_handlers/moola_xml_handler.dart';
import 'package:generator/generators/site/xml_handlers/segment_xml_handler.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:generator/util/settings.dart';
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
        // String? nextSibling = xml.nextElementSibling?.localName;
        // if (nextSibling != null && (nextSibling == XmlTag.text_with_heading.tag || nextSibling == XmlTag.heading.tag))
        //   buff.writeln('<hr>');
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
        SegmentXmlHandler(xml: xml, bookInfo: bookInfo, buff: buff).handle();
        break;
      case XmlTag.ps:
      case XmlTag.ps_ref:
        break;
      case XmlTag.meanings_section:
        buff.writeln('<hr><div class="san-meta-heading meta-heading">अर्थाः</div><div style="margin-top: ${Settings.spacing.paraMarginTopBottom}"></div>');
        buff.writeln('<div class="meanings-container">');
        _handleNesting(xml);
        buff.writeln('</div>');
        break;
      case XmlTag.word_with_meaning:
        buff.write('<div class="word-with-meaning extra-line-height">');
        _handleNesting(xml);
        buff.writeln('</div>');
        break;
      case XmlTag.meaning_word:
        String? refId = xml.getAttribute(Attribute.ref_id.tag);
        String actualRefId = refId == null ? '' : 'id = "${Constants.meaningPrefix}$refId"';
        String lang = xml.getAttribute(Attribute.lang.tag)!;
        buff.write('<span $actualRefId class="$lang-text meaning-word">${xml.innerText}</span>');
        break;
      case XmlTag.meaning:
        String lang = xml.getAttribute(Attribute.lang.tag)!;
        buff.write('<span class="san-text"> &raquo; </span><span class="$lang-text">');
        if (xml.childElements.isEmpty) buff.write(xml.innerText);
        else _handleNesting(xml);
        buff.write('</span>');
        break;
      case XmlTag.grammar_section:
        buff.writeln('<hr><div class="san-meta-heading meta-heading">व्याकरणविषयाः</div>');
        break;
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