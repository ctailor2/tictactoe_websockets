@javascript
Feature: player places marker

	As a player
	I want to place my marker
	So that I can complete my turn

	Scenario: first player clicks unoccupied space on their turn
		Given UserA & UserB are playing
		And it is UserA's turn
		When I am in UserA's browser
		And I click on the middle space
		Then I should see an 'X' in the middle space
		And I should see "Opponent's Turn"

		When I am in UserB's browser
		Then I should see an 'X' in the middle space
		And I should see "Your Turn"

	Scenario: second player clicks any space on the opponent's turn
		Given UserA & UserB are playing
		And it is UserA's turn
		When I am in UserB's browser
		And I click on the middle space
		Then I should not see an 'X' in the middle space

		When I am in UserA's browser
		Then I should not see an 'X' in the middle space