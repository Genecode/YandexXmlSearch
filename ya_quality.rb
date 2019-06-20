require 'mechanize'

class YaQuality
  attr_reader :agent, :search_form

  def initialize
    prepare_search_form
  end

  def quality(url)
    @search_form.field_with(name: 'host').value = url
    search_results = @agent.submit search_form
    search_results.search('td.luna-table__cell.luna-table__cell_type_sqi').text
  end

  private

  def prepare_search_form
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Linux Firefox'
    request_url = 'https://webmaster.yandex.ru/sqi/?host='
    page = @agent.get request_url
    @search_form = page.forms.last
  end
end