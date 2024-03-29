require_relative "../../../whitman-scripts/scripts/ruby/get_works_info.rb"
require_relative "../../../whitman-scripts/scripts/archive-wide/overrides.rb"

class TeiToEs

  ################
  #    XPATHS    #
  ################

  # in the below example, the xpath for "person" is altered
  def override_xpaths
    xpaths = {}
    xpaths["creator"] = "//profileDesc/particDesc/person[@role='scribe' or @role='sender']/persName"
    xpaths["recipient"] = "//profileDesc/particDesc/person[@role='recipient']"
    xpaths["format"] = "/TEI/text/@type"
    xpaths["rights_holder"] = "//fileDesc/publicationStmt/distributor"
    xpaths["sender"] = "//profileDesc/particDesc/person[@role='sender']/persName"
    xpaths["contributor"] = "//teiHeader//notesStmt//persName"
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
    @json["sender_k"] = get_text(@xpaths["sender"])
  end

  # def build_sender
  #   eles = @xml.xpath(@xpaths["sender"])
  #   byebug
  #   eles.map do |p|
  #     {
  #       "id" => p["id"],
  #       "name" => Datura::Helpers.normalize_space(p.text),
  #       "role" => "sender"
  #     }
  #   end
  # end

  ################
  #    FIELDS    #
  ################

  # Overrides of default behavior
  # Please see docs/tei_to_es.rb for complete instructions and examples

  def annotations_text
  end

  def category
    "Letters"
  end

  def category2
    "Letters / Scribal"
  end

  def format
    get_text(@xpaths["format"])
  end

  def language
    # TODO verify that none of these are primarily english
    "en"
  end

  # def languages
  #   # TODO verify that none of these are multiple languages
  #   [ "en" ]
  # end


  def publisher
  end

  def person
    #was recipient
    eles = @xml.xpath(@xpaths["recipient"])
    eles.map do |p|
      {
        "id" => p["id"],
        "name" => Datura::Helpers.normalize_space(p.text),
        "role" => "recipient"
      }
    end
  end

  # TODO place, publisher, rights_uri, rights_holder, source
  def rights
    get_text(@xpaths["rights"])
  end

  # TODO text other from author, title, publisher, pubplace, and date[@when]

  def uri
    "#{@options["site_url"]}/manuscripts/scribal/tei/#{@filename}.html"
  end

  def citation
    # WorksInfo is get_works_info.rb in whitman-scripts repo
    @works_info = WorksInfo.new(xml, @id, @options["threads"])
    ids, names = @works_info.get_works_info
    citations = []
    if ids && ids.length > 0
      ids.each_with_index do |id, idx|
        name = names[idx]
        citations << {
          "id" => id,
          "title" => name,
          "role" => "whitman_id"
        }
      end
    end
    citations
  end

end
