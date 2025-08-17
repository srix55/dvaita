// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:generator/generators/site/util/constants.dart';
import 'package:generator/generators/site/xml_handlers/recursive_handler.dart';
import 'package:generator/models/book_info.dart';
import 'package:generator/models/xml_tag.dart';
import 'package:random_string/random_string.dart';
import 'package:xml/xml.dart';

import '../../../models/string_with_lang.dart';

class SegmentXmlHandler {
  final XmlElement xml;
  late final BookInfo bookInfo;
  
  late final String? _id;
  late final String? _lang;
  late final String? _qm;

  // features
  late bool _fMeaning = false;
  late bool _fGrammar = false;
  late bool _fPs = false;
  late bool _em = false; // emphasis/bold

  final List<StringWithLang> _quickMeanings = [];
  
  final StringBuffer buff;

  SegmentXmlHandler({required this.xml, required this.bookInfo, required this.buff}) {
    _checkTag();
    _initAttributes();
    _initQuickMeanings();
    _initFeatures();

    if (_em == false && _id == null && _lang == null && _quickMeanings.isEmpty)
      throw Exception('$SegmentXmlHandler: Segment has no purpose - no em/id/lang or quickMeanings');
  }

  void handle() {
    String? classes = _buildSegClass();
    String segClass = classes == null ? '' : 'class="$classes"';

    String mouseOverHighlightCodeForQuickMeanings = '';
    String mouseOverId = _id == null ? 'qm-${randomAlphaNumeric(15)}' : 'qm-$_id';
    if (_quickMeanings.isNotEmpty) {
      mouseOverHighlightCodeForQuickMeanings = 'onmouseover="document.getElementById(\'$mouseOverId\').style.color=\'var(--accent)\';" onmouseout="document.getElementById(\'$mouseOverId\').style.color=\'var(--inline-meaning)\';"';
    }

    buff.write('<span${_id != null ? ' id="$_id"' : ''} $segClass $mouseOverHighlightCodeForQuickMeanings>');
    if (xml.childElements.isEmpty) buff.write('${xml.innerText}</span>');
    else {
      for (XmlNode x in xml.children) {
        if (x.nodeType == XmlNodeType.TEXT)
          buff.write((x as XmlText).value);
        else if (x.nodeType == XmlNodeType.ELEMENT) {
          Set<XmlTag> deniedTags = {XmlTag.book, XmlTag.book_title, XmlTag.book_author,
            XmlTag.vyakhyana_info, XmlTag.vyakhyana_id, XmlTag.vyakhyana_title,
            XmlTag.vyakhyana_author, XmlTag.vyakhyana_lang, XmlTag.chapter, XmlTag.moola,
            XmlTag.text_with_heading, XmlTag.heading};
          RecursiveHandler(deniedTags: deniedTags, bookInfo: bookInfo, skipTags: {}, buff: buff, xmlElement: x as XmlElement).handle();
        }
      }
      buff.write('</span>');
    }
    if (_quickMeanings.isNotEmpty) buff.write('<span style="position: relative; display: inline-block;">');
    for (StringWithLang quickMeaning in _quickMeanings) {
      buff.write('<span class="${quickMeaning.lang}-inline inline" id="$mouseOverId">${quickMeaning.string}</span>');
    }
    if (_quickMeanings.isNotEmpty) buff.write('</span>');

    // Handle links
    if (_fMeaning || _fGrammar || _fPs) buff.write('<span class="superscript-links-container">');
    if (_fMeaning) buff.write('<a href="#meaning-ref-$_id" class="meaning-link">[m]</a>');
    if (_fGrammar) buff.write('<a href="#grammar-ref-$_id" class="grammar-link">[g]</a>');
    if (_fPs) buff.write('<a href="#ps-ref-$_id" class="ps-link">[${Constants.psSymbol}]</a>');
    if (_fMeaning || _fGrammar || _fPs) buff.write('</span>');
  }

  String? _buildSegClass() {
    String? segClass;
    // Check if this segment was in a heading. To retain the heading class with lang change, for which it was likely segmented
    if (xml.parentElement?.localName == XmlTag.heading.tag) segClass = _lang != null ? '$_lang-secondary-heading' : '';
    if (_em) segClass = segClass == null ? 'em' : '$segClass em';
    if (_quickMeanings.isNotEmpty) {
      if (segClass != null) segClass = '$segClass dotted-underline';
      else segClass = 'dotted-underline';
    }
    return segClass;
  }

  void _checkTag() {
    if (xml.localName != XmlTag.s.tag)
      throw Exception('$SegmentXmlHandler: XmlElement is supposed to be a \'${XmlTag.s.tag}\' element. But, it is \'${xml.localName}\'');
  }

  void _initAttributes() {
    _id = xml.getAttribute(Attribute.id.tag);
    _lang = xml.getAttribute(Attribute.lang.tag);
    _qm = xml.getAttribute(Attribute.qm.tag);
    _em = xml.attributes.any((att) => att.localName == Attribute.em.tag);
  }
  
  void _initFeatures() {
    List<String> features = xml.getAttribute(Attribute.feat.tag)?.split(',') ?? [];
    for (String feat in features) {
      switch(feat) {
        case 'm': _fMeaning = true; break;
        case 'g': _fGrammar = true; break;
        case 'ps': _fPs = true; break;
      }
    }
  }

  void _initQuickMeanings() {
    if (_qm != null) {
      List<String> words = _qm.split('_');
      for (String w in words) {
        if (w.contains('#')) { // Has language too, else use default sanskrit
          List<String> wordAndLanguage = w.split('#');
          String lang = wordAndLanguage[0];
          String word = wordAndLanguage[1];
          _quickMeanings.add(StringWithLang(string: word, lang: lang));
        } else {
          _quickMeanings.add(StringWithLang(string: w, lang: 'san'));
        }
      }
    }
  }
}