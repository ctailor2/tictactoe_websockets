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


Then(/^a new game should have started$/) do
	server = page.driver.app
	expect(server.game).to be_an_instance_of(Game)
end