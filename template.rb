gem 'pry-byebug', '~> 3.7.0', group: :development
gem 'lograge', '~> 0.10.0'
gem 'sqlite3','~> 1.3.6'
gem 'logstash-event', '~> 1.2.02'

environment 'config.logger = Logger.new(STDOUT)'
environment 'config.i18n.fallbacks = true'
environment 'config.lograge.enabled = true'#, env: :production
environment 'config.lograge.formatter = Lograge::Formatters::Logstash.new'#, env: :production

environment 'config.web_console.whitelisted_ips = "172.0.0.0/8" if defined?(WebConsole)', env: :development
