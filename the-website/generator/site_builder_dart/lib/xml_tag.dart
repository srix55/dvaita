enum XmlTag {
  book(attributes: {}, tag: 'book'),
  book_title(attributes: {Attribute.lang}, tag: 'book-title'),
  vyakhyana_info(attributes: {}, tag: 'vyakhyana-info'),
  vyakhyana_id(attributes: {}, tag: 'vyakhyana-id'),
  vyakhyana_title(attributes: {Attribute.lang}, tag: 'vyakhyana-title'),
  vyakhyana_author(attributes: {Attribute.lang}, tag: 'vyakhyana-author'),
  vyakhyana_lang(attributes: {}, tag: 'vyakhyana-lang'),
  chapter(attributes: {Attribute.name, Attribute.number, Attribute.lang}, tag: 'chapter'),
  text_with_heading(attributes: {}, tag: 'text-with-heading'),
  heading(attributes: {Attribute.level, Attribute.lang}, tag: 'heading'),
  heading_content(attributes: {Attribute.lang}, tag: 'heading-content'),
  moola(attributes: {Attribute.id, Attribute.lang}, tag: 'moola'),
  shloka(attributes: {Attribute.alankara, Attribute.vruttam}, tag: 'shloka'),
  anvaya(attributes: {Attribute.lang}, tag: 'anvaya'),
  vyakhyana(attributes: {Attribute.lang, Attribute.ref_id}, tag: 'vyakhyana'),
  p(attributes: {Attribute.lang}, tag: 'p'),
  s(attributes: {Attribute.em, Attribute.lang, Attribute.id}, tag: 's'),
  quick_meaning(attributes: {Attribute.lang, Attribute.ref_id}, tag: 'quick-meaning'),
  ps(attributes: {}, tag: 'ps'),
  ps_ref(attributes: {Attribute.lang, Attribute.ref_id}, tag: 'ps-ref'),
  meanings_section(attributes: {}, tag: 'meanings-section'),
  meaning_point(attributes: {}, tag: 'meaning-point'),
  meaning_word(attributes: {Attribute.lang, Attribute.ref_id}, tag: 'meaning-word'),
  meaning(attributes: {Attribute.lang}, tag: 'meaning'),
  grammar_section(attributes: {}, tag: 'grammar-section'),
  grammar_point(attributes: {Attribute.lang, Attribute.ref_id}, tag: 'grammar-point'),
  shabda_roopa(attributes: {Attribute.ending, Attribute.linga, Attribute.name}, tag: 'shabda-roopa'),
  vibhakti(attributes: {Attribute.id}, tag: 'vibhakti'),
  vachana(attributes: {Attribute.id}, tag: 'vachana'),
  kriya_roopa(attributes: {Attribute.dhatu, Attribute.lakara, Attribute.dhatu_meaning, Attribute.gana, Attribute.prayoga, Attribute.padi}, tag: 'kriya-roopa'),
  purusha(attributes: {Attribute.id}, tag: 'purusha');

  final Set<Attribute> attributes;
  final String tag;

  static XmlTag fromTag(String tag) {
    for (XmlTag t in XmlTag.values) {
      if (t.tag == tag) return t;
    }
    throw Exception('No such tag: $tag');
  }

  const XmlTag({required this.attributes, required this.tag});
}

enum Attribute {
  lang, name, number, level, id, alankara, vruttam, em, ref_id, ending, linga,
  vachana, dhatu, lakara, dhatu_meaning, gana, prayoga, padi, purusha
}