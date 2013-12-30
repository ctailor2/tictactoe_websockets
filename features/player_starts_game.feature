Feature: player starts game

	As a player
	I want to start a game
	So that I can play against a challenger

	Scenario: start game
		Given I am not yet playing
		When I start a game
		Then I should see "Welcome to TicTacToe!"
		And I should see "Waiting for Challenger"
