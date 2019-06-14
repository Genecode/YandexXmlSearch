require 'net/http'

class XMLProxyRequest
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes = defaults.merge(attributes)
    @keyword = attributes[:keyword]
    @page_number = attributes[:page_number]
    @results_on_page = attributes[:result_on_page]
    @region = attributes[:region]
    @sortby = attributes[:sortby]
    @filter = attributes[:filter]
    @user = attributes[:user] || raise(ArgumentError.new("You must specify xmlproxy.ru user"))
    @key = attributes [:key] || raise(ArgumentError.new("You must specify xmlproxy.ru key"))
  end

  def defaults
    { page_number: '0',
      result_on_page: '10',
      region: '2',
      filter: 'none',
      sortby: 'rlv' }
  end

  def xml_data
    create_url
    Net::HTTP.get_response(URI.parse(@xml_url)).body
  end

  def to_file(filename)
    File.write(filename, xml_data)
  end

  private

  def create_url
    base_url = 'https://xmlproxy.ru/search/xml?'
    query_url = URI.encode_www_form([['query', @keyword],
                                     ['p', @page_number],
                                     ['numdoc', @results_on_page],
                                     ['lr', @region],
                                     ['key', @key],
                                     ['user', @user],
                                     ['sortby', @sortby],
                                     ['filter', @filter]])
    @xml_url = base_url + query_url
  end
end