@javascript
Feature: Player wins or loses

	As a player
	I want to win, lose, or draw
	So that I can conclude the game

	Scenario: first player wins with horizontal pattern
		Given UserA & UserB are playing
		And UserA clicked on space 1 on turn 1
		And UserB clicked on space 4 on turn 2
		And UserA clicked on space 2 on turn 3
		And UserB clicked on space 5 on turn 4
		And it is UserA's turn
		When I am in UserA's browser
		And I click on space 3
		Then I should see "You Win!"
		And I should see "Game Over"

		When I am in UserB's browser
		Then I should see "You Lose."
		And I should see "Game Over"

	Scenario: first player wins with vertical pattern
		Given UserA & UserB are playing
		And UserA clicked on space 1 on turn 1
		And UserB clicked on space 2 on turn 2
		And UserA clicked on space 4 on turn 3
		And UserB clicked on space 5 on turn 4
		And it is UserA's turn
		When I am in UserA's browser
		And I click on space 7
		Then I should see "You Win!"
		And I should see "Game Over"

		When I am in UserB's browser
		Then I should see "You Lose."
		And I should see "Game Over"

	Scenario: first player wins with diagonal pattern
		Given UserA & UserB are playing
		And UserA clicked on space 1 on turn 1
		And UserB clicked on space 3 on turn 2
		And UserA clicked on space 5 on turn 3
		And UserB clicked on space 7 on turn 4
		And it is UserA's turn
		When I am in UserA's browser
		And I click on space 9
		Then I should see "You Win!"
		And I should see "Game Over"

		When I am in UserB's browser
		Then I should see "You Lose."
		And I should see "Game Over"

	Scenario: game ends in a draw with no win patterns
		Given UserA & UserB are playing
		And UserA clicked on space 1 on turn 1
		And UserB clicked on space 5 on turn 2
		And UserA clicked on space 6 on turn 3
		And UserB clicked on space 3 on turn 4
		And UserA clicked on space 7 on turn 5
		And UserB clicked on space 4 on turn 6
		And UserA clicked on space 2 on turn 7
		And UserB clicked on space 8 on turn 8
		And it is UserA's turn
		When I am in UserA's browser
		And I click on space 9
		Then I should see "Draw."
		And I should see "Game Over"

		When I am in UserB's browser
		Then I should see "Draw."
		And I should see "Game Over"
