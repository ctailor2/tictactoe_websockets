$LOAD_PATH << File.expand_path('../../..', __FILE__)
require 'capybara/cucumber'
require 'app'
Capybara.app = App