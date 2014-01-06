# Users enter lobby

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

Then(/^new game requirements should not be met$/) do
	server = page.driver.app
	expect(server.new_game_req_met?).to be_false
end

Then(/^a new game should not have started$/) do
	server = page.driver.app
	expect(server.game).to be_nil
end

Then(/^new game requirements should be met$/) do
	server = page.driver.app
	expect(server.new_game_req_met?).to be_true
end

Then(/^a new game should have started$/) do
	server = page.driver.app
	expect(server.game).to be_an_instance_of(Game)
end