@javascript
Feature: player places marker

	As a player
	I want to place my marker
	So that I can complete my turn

	Scenario: first player clicks unoccupied space on their turn
		Given UserA & UserB are playing
		And it is UserA's turn
		When I am in UserA's browser
		And I click on space 5
		Then I should see an 'X' in space 5
		And I should see "Opponent's Turn"

		When I am in UserB's browser
		Then I should see an 'X' in space 5
		And I should see "Your Turn"

	Scenario: second player clicks any space on the opponent's turn
		Given UserA & UserB are playing
		And it is UserA's turn
		When I am in UserB's browser
		And I click on space 5
		Then I should not see an 'X' in space 5

		When I am in UserA's browser
		Then I should not see an 'X' in space 5

	Scenario: second player clicks unoccupied space on their turn
		Given UserA & UserB are playing
		And UserA clicked on space 5 on turn 1
		And it is UserB's turn
		When I am in UserB's browser
		And I click on space 4
		Then I should see an 'O' in space 4

		When I am in UserA's browser
		Then I should see an 'O' in space 4

	Scenario: first player clicks any space on the opponent's turn
		Given UserA & UserB are playing
		And UserA clicked on space 5 on turn 1
		And it is UserB's turn
		When I am in UserA's browser
		And I click on space 4
		Then I should not see an 'X' in space 4

		When I am in UserB's browser
		Then I should not see an 'X' in space 4

	Scenario: second player clicks occupied space on their turn
		Given UserA & UserB are playing
		And UserA clicked on space 5 on turn 1
		And it is UserB's turn
		When I am in UserB's browser
		And I click on space 5
		Then I should not see an 'O' in space 5
		And I should see "Your Turn"

		When I am in UserA's browser
		Then I should not see an 'O' in space 5
		And I should see "Opponent's Turn"
