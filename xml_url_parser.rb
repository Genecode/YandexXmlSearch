require 'mechanize'

class XmlUrlParser
  attr_reader :urls

  def initialize(xml_data)
    @xml_data = xml_data
    @urls = []
  end

  def parse
    @urls = @xml_data.search('url').map(&:text)
  end
end
