$LOAD_PATH << File.expand_path('../../..', __FILE__)
require 'app'
require 'capybara/cucumber'
Capybara.app = App
Capybara.javascript_driver = :selenium
Capybara.register_driver :selenium do |app|
	Capybara::Selenium::Driver.new(app, :browser => :chrome)
end