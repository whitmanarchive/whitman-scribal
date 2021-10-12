class TeiToEs

  ################
  #    XPATHS    #
  ################

  # in the below example, the xpath for "person" is altered
  def override_xpaths
    xpaths = {}
    xpaths["creator"] = "//profileDesc/particDesc/person[@role='scribe']/persName"
    xpaths["format"] = "/TEI/text/@type"
    xpaths["rights_holder"] = "//fileDesc/publicationStmt/distributor"
    return xpaths
  end

  #################
  #    GENERAL    #
  #################

  # Add more fields
  #  make sure they follow the custom field naming conventions
  #  *_d, *_i, *_k, *_t
  def assemble_collection_specific
    # TODO custom field text_type_k
  end

  ################
  #    FIELDS    #
  ################

  # Overrides of default behavior
  # Please see docs/tei_to_es.rb for complete instructions and examples

  def annotations_text
  end

  def category
    "correspondence"
  end

  def format
    get_text(@xpaths["format"])
  end

  def language
    # TODO verify that none of these are primarily english
    "en"
  end

  def languages
    # TODO verify that none of these are multiple languages
    [ "en" ]
  end

  def person
  end

  def publisher
  end

  def recipient
  end

  # TODO place, publisher, rights_uri, rights_holder, source
  def rights
    get_text(@xpaths["rights"])
  end

  def subcategory
    "scribal"
  end

  # TODO text other from author, title, publisher, pubplace, and date[@when]

  def uri
    "#{@options["site_url"]}/manuscripts/scribal/tei/#{@filename}.html"
  end

end
