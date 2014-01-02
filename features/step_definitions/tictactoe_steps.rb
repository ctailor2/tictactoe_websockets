# Player starts game

# Given(/^I am not yet playing$/) do
# end

# When(/^I start a game$/) do
# 	visit "/"
# end

# Then(/^I should see "(.*?)"$/) do |message|
# 	expect(page).to have_text(message)
# end

# # Player joins game

# Given(/^a player has already started a game$/) do
# 	session = Capybara::Session.new(:rack_test, App)
# 	session.visit "/"
# end

# When(/^I join the game$/) do
# 	visit "/"
# end

# Then(/^not "(.*?)"$/) do |message|
# 	expect(page).not_to have_text(message)
# end

Given(/^the following users exist:$/) do |table|
  # table is a Cucumber::Ast::Table
end

When(/^I am in (User.{1})'s browser$/) do |name|
	Capybara.session_name = name
end

When(/^I enter the lobby$/) do
	visit "/"
end

Then(/^I should see "(.*?)"$/) do |message|
	expect(page).to have_text(message)
end

Then(/^not "(.*?)"$/) do |message|
	expect(page).not_to have_text(message)
end