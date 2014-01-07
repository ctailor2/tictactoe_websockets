@javascript
Feature: users enter lobby

	The lobby is where users meet to play tictactoe against each other. Once exactly two users have entered the lobby, a new game starts with the first user's turn.

	Scenario: two users enter the lobby
		Given the following users exist:
			| Name  |
			| UserA |
			| UserB |
		When I am in UserA's browser
		And I enter the lobby
		Then I should see "Welcome to TicTacToe!"
		And I should see "Waiting for Challenger"
		And a new game should not have started
		But I should not see the game board

		When I am in UserB's browser
		And I enter the lobby
		Then I should see "Welcome to TicTacToe!"
		But not "Waiting for Challenger"
		And a new game should have started
		And I should see the game board
		And I should see "Opponent's Turn"

		When I am in UserA's browser
		Then I should see "Your Turn"
		But not "Waiting for Challenger"