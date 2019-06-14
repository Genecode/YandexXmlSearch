require 'nokogiri'

class XmlUrlParser < Nokogiri::XML::SAX::Document
  attr_accessor :urls

  def initialize
    @urls = []
    @is_url = false
  end

  def start_element name, attrs = []
    @is_url = name.eql?('url')
  end

  def characters string
    string.strip!
    @urls.push(string) if @is_url
  end

  def end_element name; end
end
