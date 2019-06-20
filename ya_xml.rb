require 'mechanize'

class YaXml
  attr_accessor :keyword, :url

  def initialize(attributes = {})
    @keyword = attributes[:keyword]
    @request_params = defaults.merge(attributes[:request_params] || {})
    @url = attributes [:url] || raise(ArgumentError, 'You must specify url')
    @user = attributes[:user] || raise(ArgumentError, 'You must specify user')
    @key = attributes [:key] || raise(ArgumentError, 'You must specify users key')
  end

  def defaults
    { page_number: '0',
      result_on_page: '10',
      region: '2',
      filter: 'none',
      sortby: 'rlv'}
  end

  def xml_data
    agent = Mechanize.new
    agent.get(URI.parse(create_url))
  end

  private

  def create_url
    query_url = URI.encode_www_form([['query', @keyword],
                                     ['p', @request_params[:page_number]],
                                     ['numdoc', @request_params[:result_on_page]],
                                     ['lr', @request_params[:region]],
                                     ['key', @key],
                                     ['user', @user],
                                     ['sortby', @request_params[:sortby]],
                                     ['filter', @request_params[:filter]]])
    @url + query_url
  end
end