$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'tictactoe'
require 'capybara/cucumber'
require 'rack/handler/puma'

Capybara.app = Rack::Builder.parse_file(File.expand_path('../../../config.ru', __FILE__)).first
Capybara.server do |app, port|
	Rack::Handler::Puma.run(app, :Port => port)
end
Capybara.javascript_driver = :selenium
Capybara.register_driver :selenium do |app|
	Capybara::Selenium::Driver.new(app, :browser => :chrome)
end