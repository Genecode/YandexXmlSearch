require_relative 'ranking'
config = YAML.load(File.open('config.yml'))
Ranking.execute('rails', config)