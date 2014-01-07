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

Then(/^I should not see the game board$/) do
	expect(page).not_to have_selector('.space', :count => 9)
end

Then(/^I should see the game board$/) do
	expect(page).to have_selector('.space', :count => 9)
end

Then(/^a new game should not have started$/) do
	server = page.driver.app
	expect(server.game).to be_nil
end

Then(/^a new game should have started$/) do
	server = page.driver.app
	expect(server.game).to be_an_instance_of(Game)
end

Given(/^UserA & UserB are playing$/) do
	Capybara.using_session("UserA") { visit "/" }
	Capybara.using_session("UserB") { visit "/" }
end

Given(/^it is UserA's turn$/) do
end

When(/^I click on the middle space$/) do
	middle_space = page.find_by_id('5')
	middle_space.click
end

Then(/^I should see an 'X' in the middle space$/) do
	middle_space = page.find_by_id('5')
	expect(middle_space).to have_text('X')
end
