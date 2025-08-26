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
      case XmlTag.pada_cheda:
        buff.writeln('<hr><div class="san-meta-heading meta-heading">पदच्छेदः</div>');
        if (xml.childElements.isEmpty) {
          buff.writeln('<div class="san-text text extra-line-height">${xml.innerText}</div>');
        } else {
          buff.write('<div class="san-text extra-line-height">');
          _handleNesting(xml);
          buff.write('</div>');
        }
        break;
      case XmlTag.vyakhyana:
        String vyId = xml.getAttribute(Attribute.ref_id.tag)!;
        String lang = xml.getAttribute(Attribute.lang.tag) ?? 'san';
        XmlElement? previousSibling = xml.previousElementSibling;
        if (previousSibling?.localName == XmlTag.text_with_heading.tag || previousSibling?.localName == XmlTag.anvaya.tag || previousSibling?.localName == XmlTag.vyakhyana.tag || previousSibling?.localName == XmlTag.pada_cheda.tag)
          buff.writeln('<hr>');
        buff.writeln('<div class="san-meta-heading meta-heading">व्याख्यानं - ${bookInfo.vyakhyanaIdToAuthorNameMap[vyId]!.string}</div>');
        if (xml.childElements.isEmpty) {
          buff.writeln('<div class="vyakhyana $lang-text text extra-line-height">${xml.innerText}</div>');
        } else {
          buff.write('<div class="vyakhyana $lang-text text extra-line-height">');
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
        buff.writeln('</div> <!-- meanings-section end -->');
        break;
      case XmlTag.word_with_meaning:
        buff.write('<div class="word-with-meaning">');
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
        buff.writeln('<hr><div class="san-meta-heading meta-heading">व्याकरणविषयाः</div><div style="margin-top: ${Settings.spacing.paraMarginTopBottom}"></div>');
        buff.writeln('<div class="grammar-container">');
        _handleNesting(xml);
        buff.writeln('</div> <!-- grammar-container end -->');
        break;
      case XmlTag.grammar_point:
        String? refId = xml.getAttribute(Attribute.ref_id.tag);
        String grammarPrefix = Constants.grammarPrefix;
        String actualRefId = refId == null ? '' : 'id = "$grammarPrefix$refId"';
        buff.write('<div $actualRefId class="grammar-point">');
        _handleNesting(xml);
        String? extLinks = xml.getAttribute(Attribute.ext_link.tag);
        if (extLinks != null) {
          buff.writeln('<div style="display: inline-block; margin-top: 8px; width: 100%;">');
          List<String> linkWithName = extLinks.split('|');
          for (String l in linkWithName) {
            var link = LinkWithName.parse(l);
            buff.write('<a href="${link.url}" class="external-link ${link.lang}-text" target="_blank" rel="noopener noreferrer">${link.name}</a> ');
          }
          buff.writeln("</div>");
        }
        buff.writeln('</div>');
        break;
      case XmlTag.shabda_roopa:
        buff.write('<div class="shabda-roopa san-text">');
        StringBuffer shabdaMeta = StringBuffer();
        String? ending = xml.getAttribute(Attribute.ending.tag);
        String? linga = xml.getAttribute(Attribute.linga.tag);
        String? shabdaName = xml.getAttribute(Attribute.name.tag);
        if (ending != null) shabdaMeta.write('$endingकारान्तः ');
        if (linga != null) shabdaMeta.write('$linga ');
        if (shabdaName != null) shabdaMeta.write(' <span class="shabda">$shabdaName शब्दः</span>');
        if (shabdaMeta.isNotEmpty)
          buff.writeln('<div class="shabda-meta san-text">${shabdaMeta.toString()}</div>');
        if (xml.childElements.isNotEmpty)
          buff.writeln('<table><tr><th class="san"></th><th class="san-text">एकवचनं</th><th class="san-text">द्विवचनं</th><th class="san-text">बहुवचनं</th></tr>');
        _handleNesting(xml);
        if (xml.childElements.isNotEmpty)
          buff.writeln('</table>');
        buff.writeln('</div>');
        break;
      case XmlTag.vibhakti:
        String vibhakti = xml.getAttribute(Attribute.name.tag)!;
        buff.write('<tr><td class="san-text">$vibhakti</td>');
        _handleNesting(xml);
        buff.write('</tr>');
        break;
      case XmlTag.vachana:
        // String vachana = xml.getAttribute(Attribute.vachana.tag)!;
        buff.write('<td class="san-text">${xml.innerText}</td>');
        break;
      case XmlTag.kriya_roopa:
        buff.write('<div class="kriya-roopa san-text">');
        StringBuffer kriyaMeta = StringBuffer();
        String dhatu = xml.getAttribute(Attribute.dhatu.tag)!;
        String? dhatuMeaning = xml.getAttribute(Attribute.dhatu_meaning.tag);
        String? gana = xml.getAttribute(Attribute.gana.tag);
        String? karmaka = xml.getAttribute(Attribute.karmaka.tag);
        String? it = xml.getAttribute(Attribute.it.tag);
        kriyaMeta.write('<span class="dhatu">$dhatu </span>');
        if (dhatuMeaning != null) kriyaMeta.write('<span class="dhatu">$dhatuMeaning</span> ');
        if (gana != null) kriyaMeta.write('$gana ');
        if (karmaka != null) kriyaMeta.write('$karmaka ');
        if (it != null) kriyaMeta.write('$it ');
        if (kriyaMeta.isNotEmpty)
          buff.writeln('<div class="kriya-meta san-text">${kriyaMeta.toString()}</div>');
        _handleNesting(xml);
        buff.writeln('</div>');
        break;
      case XmlTag.lakara_roopa:
        buff.write('<div class="lakara-roopa san-text">');
        StringBuffer lakaraMeta = StringBuffer();
        String lakara = xml.getAttribute(Attribute.lakara.tag)!;
        String? prayoga = xml.getAttribute(Attribute.prayoga.tag);
        String? padi = xml.getAttribute(Attribute.padi.tag);
        lakaraMeta.write('$lakara ');
        if (prayoga != null) lakaraMeta.write('$prayoga ');
        if (padi != null) lakaraMeta.write('$padi ');
        if (lakaraMeta.isNotEmpty)
          buff.writeln('<div class="lakara-meta san-text">${lakaraMeta.toString()}</div>');
        if (xml.childElements.isNotEmpty)
          buff.writeln('<table><tr class="san-text"><th></th><th class="san-text">एकवचनं</th><th class="san-text">द्विवचनं</th><th class="san-text">बहुवचनं</th></tr>');
        _handleNesting(xml);
        if (xml.childElements.isNotEmpty)
          buff.writeln('</table>');
        buff.writeln('</div>');
        break;
      case XmlTag.purusha:
        String purusha = xml.getAttribute(Attribute.name.tag)!;
        buff.write('<tr><td class="san-text">$purusha</td>');
        _handleNesting(xml);
        buff.write('</tr>');
        break;
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

class LinkWithName {
  final String lang;
  final String name;
  final String url;

  LinkWithName(this.lang, this.name, this.url);

  factory LinkWithName.parse(String text) {
    final regex = RegExp(r'^\(([^:]+):([^)]+)\)\[([^\]]+)\]$');
    final match = regex.firstMatch(text);

    if (match == null) {
      throw FormatException("Invalid format: $text");
    }

    return LinkWithName(
      match.group(1)!, // language
      match.group(2)!, // name
      match.group(3)!, // url
    );
  }
}