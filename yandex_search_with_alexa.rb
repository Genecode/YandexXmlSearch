require_relative 'xml_proxy_request'
require_relative 'xml_url_parser'
require 'nokogiri'
require 'alexa'
require 'yaml'
require 'csv'

class YandexSearchWithAlexa
  def self.execute(keyword)
    self.new(keyword).tap do |handler|
      puts 'Request to yandex'
      handler.get_xml_file
      urls = handler.parse_xml_file
      # puts urls
      puts 'Collect ranks'
      ranks = handler.request_alexa_ranks(urls)
      puts 'Save csv data'
      handler.save_ranks_to_csv(ranks)
      puts 'Done!'
    end
  end

  def initialize(keyword)
    @keyword = keyword
    @xml_data_file = 'data.xml'
    @config = YAML.load(File.open('config.yml'))
  end

  def get_xml_file
    xmlproxy = XMLProxyRequest.new(@config[:xmlproxy])
    xmlproxy.keyword = @keyword
    xmlproxy.to_file(@xml_data_file)
  end

  def parse_xml_file
    xml_parser = Nokogiri::XML::SAX::Parser.new(XmlUrlParser.new)
    xml_parser.parse_file(@xml_data_file)
    xml_parser.document.urls
  end

  def request_alexa_ranks(urls)
    alexa_client = Alexa::Client.new(@config[:alexa])
    ranks = urls.each_with_object({}) do |url, rank|
      rank[url] = alexa_client.url_info(url: url).rank
    end
    ranks.sort_by { |url, rank| -rank }
  end

  def save_ranks_to_csv(ranks)
    CSV.open('output.csv', "w") do |csv|
      ranks.each { |elem| csv << elem }
    end
  end
end