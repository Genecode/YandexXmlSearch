require 'mechanize'

class AlexaRank
  attr_reader :agent

  def initialize
    prepare_agent
  end

  def rank(url)
    base_url = 'http://data.alexa.com/data?cli=10&dat=s&url='
    request_url = base_url + url
    page = agent.get request_url
    search_result = page.search('POPULARITY').first
    search_result.attribute('TEXT').to_s
  end

  def prepare_agent
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Linux Firefox'
  end
end