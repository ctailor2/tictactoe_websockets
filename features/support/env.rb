require 'capybara/cucumber'
Capybara.app = Rack::Builder.parse_file(File.expand_path('../../../config.ru', __FILE__)).first
Capybara.server do |app, port|
	require 'rack/handler/puma'
	Rack::Handler::Puma.run(app, :Port => port)
end
Capybara.javascript_driver = :selenium
Capybara.register_driver :selenium do |app|
	Capybara::Selenium::Driver.new(app, :browser => :chrome)
end