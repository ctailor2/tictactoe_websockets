Given(/^I am not yet playing$/) do
end

When(/^I start a game$/) do
	visit "/"
end

Then(/^I should see "(.*?)"$/) do |message|
	expect(page).to have_text(message)
end