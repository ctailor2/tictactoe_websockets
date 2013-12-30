Feature: player joins game

	As a player
	I want to join a game
	So that I can play against the player who started it

	Scenario: join game
		Given I am not yet playing
		And a player has already started a game
		When I join the game
		Then I should see "Welcome to TicTacToe!"
		But not "Waiting for Challenger"