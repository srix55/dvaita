enum XmlTag {
  book(attributes: {Attribute.id, Attribute.book_type}, tag: 'book'),
  book_title(attributes: {Attribute.lang}, tag: 'book-title'),
  book_author(attributes: {Attribute.lang}, tag: 'book-author'),
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
  shloka(attributes: {Attribute.lang, Attribute.alankara, Attribute.vruttam}, tag: 'shloka'),
  gadya(attributes: {Attribute.lang}, tag: 'gadya'),
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
  lang(tag: 'lang'), name(tag: 'name'), number(tag: 'number'), level(tag: 'level'),
  id(tag: 'id'), alankara(tag: 'alankara'), vruttam(tag: 'vruttam'), em(tag: 'em'),
  ref_id(tag: 'ref-id'), ending(tag: 'ending'), linga(tag: 'linga'), vachana(tag: 'vachana'),
  dhatu(tag: 'dhatu'), lakara(tag: 'lakara'), dhatu_meaning(tag: 'dhatu-meaning'),
  gana(tag: 'gana'), prayoga(tag: 'prayoga'), padi(tag: 'padi'), purusha(tag: 'purusha'),
  book_type(tag: 'book-type');

  final String tag;

  const Attribute({required this.tag});
}