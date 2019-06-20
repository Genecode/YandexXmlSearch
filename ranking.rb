require_relative 'ya_xml'
require_relative 'xml_url_parser'
require_relative 'ya_quality'
require_relative 'alexa_rank'
require 'nokogiri'
require 'alexa'
require 'csv'

class Ranking
  def self.execute(keyword, config)
    self.new(keyword, config).tap do |handler|
      puts 'Request to yandex'
      urls = handler.parse_xml(handler.get_xml)
      puts 'Collect ranks'
      handler.collect_ranks(urls)
      puts 'Save csv data'
      handler.save_ranks_to_csv
      puts 'Done!'
    end
  end

  def initialize(keyword, config)
    @keyword = keyword
    @config = config
    @result = []
  end

  def get_xml
    xml = YaXml.new(@config[:xmlapi])
    xml.keyword = @keyword
    xml.xml_data
  end

  def parse_xml(xml_data)
    xml_parser = XmlUrlParser.new(xml_data)
    xml_parser.parse
    xml_parser.urls
  end

  def collect_ranks(urls)
    url = Struct.new(:name, :alexa, :ya_quality)
    ya_qualifier = YaQuality.new
    alexa_qualifier = AlexaRank.new
    urls.each do |el|
      puts el
      @result << url.new(el,
                         alexa_qualifier.rank(el),
                         ya_qualifier.quality(el))
    end
    @result
  end

  def save_ranks_to_csv
    @result.sort_by! { |elem| - elem.alexa.to_i }
    CSV.open('output.csv', "w") do |csv|
      @result.each { |elem| csv << elem.to_a }
    end
  end
end