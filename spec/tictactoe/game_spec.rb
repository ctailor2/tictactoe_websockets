require 'spec_helper'

describe Game do
	let(:game) do
		clients = []
		2.times do |i|
			clients << double("client#{i + 1}").as_null_object
		end
		Game.new(clients).as_null_object
	end

	describe "#initialize" do
		it "responds to #players" do
			expect(game).to respond_to(:players)
		end

		it "responds to #board" do
			expect(game).to respond_to(:board)
		end
	end

	describe "#players" do
		it "is a collection of Player objects" do
			expect(game.players.all? { |player| player.is_a?(Player) }).to be_true
		end
	end

	describe "#board" do
		it "has 9 spaces" do
			expect(game.board.length).to eq(9)
		end

		it "is initially empty" do
			expect(game.board.none?).to be_true
		end
	end

	describe "#turn!" do
		it "sends the message 'Your Turn' to the first player" do
			first_player = game.players.first
			expect(game).to receive(:send_data).with(:turn_message, 'Your Turn', first_player)
			game.turn!
		end

		it "sends the message 'Opponent's Turn' to the second player" do
			second_player = game.players.last
			expect(game).to receive(:send_data).with(:turn_message, "Opponent's Turn", second_player)
			game.turn!
		end

		it "rotates the players" do
			expect(game.players).to receive(:rotate!)
			game.turn!
		end
	end

	describe "#show" do
		it "sends the display message 'Show' to both players" do
			expect(game).to receive(:send_data).with(:display_message, 'show', game.players)
			game.show
		end
	end

	describe "#send_data" do
		context "when a single player is specified" do
			it "sends the specified data to the specified player(s)" do
				label = :data_label
				data = 'message for single player'
				player = game.players.first
				expect(player.client).to receive(:send).with({ label => data }.to_json)
				game.send_data(label, data, player)
			end
		end

		context "when a collection of players is specified" do
			it "sends the specified data to the specified player(s)" do
				label = :data_label
				data = 'message for multiple players'
				players = game.players
				expect(players.first.client).to receive(:send).with({ label => data }.to_json)
				expect(players.last.client).to receive(:send).with({ label => data }.to_json)
				game.send_data(label, data, players)
			end
		end
	end

	describe "#receive_data" do
		context "when the data has the label 'marker_message'" do
			let(:data) { "{\"marker_message\":2}" }

			describe "when the space number is unoccupied" do
				it "fills in the board space with the sender's marker" do
					game.receive_data(data)
					expect(game.board[1]).to eq("X")
				end

				it "sends a marker message containing the sender's space number and marker to both players" do
					expect(game).to receive(:send_data).with(:marker_message, [2, game.players.last.marker], game.players)
					game.receive_data(data)
				end

				context "when filling the space results in a win condition for the sender" do
					before do
						spaces = [5, 8]
						spaces.each do |index|
							game.board[index - 1] = "X"
						end
					end

					it "does not complete the turn" do
						expect(game).not_to receive(:turn!)
						game.receive_data(data)
					end

					it "announces the winner" do
						expect(game).to receive(:announce_winner).with(game.players.last)
						game.receive_data(data)
					end

					it "makes the game over" do
						expect(game).to receive(:over)
						game.receive_data(data)
					end
				end

				context "when filling the space does not result in a win condition for the sender" do
					it "completes the turn" do
						expect(game).to receive(:turn!)
						game.receive_data(data)
					end

					it "does not announce the winner" do
						expect(game).not_to receive(:announce_winner).with(game.players.last)
						game.receive_data(data)
					end

					it "does not make the game over" do
						expect(game).not_to receive(:over)
						game.receive_data(data)
					end
				end
			end

			describe "when the space number is occupied" do
				before do
					game.board[1] = "O"
				end

				it "does not fill in the board space with the sender's marker" do
					game.receive_data(data)
					expect(game.board[1]).not_to eq("X")
				end

				it "does not send a marker message containing the sender's space number and marker to both players" do
					expect(game).not_to receive(:send_data).with(:marker_message, [2, game.players.last.marker], game.players)
					game.receive_data(data)
				end

				it "does not complete the turn" do
					expect(game).not_to receive(:turn!)
					game.receive_data(data)
				end
			end
		end
	end

	describe "#win?" do
		context "when the board has a horizontal win pattern" do
			patterns = [
				[1, 2, 3],
				[4, 5, 6],
				[7, 8, 9]
			]

			patterns.each do |spaces|
				before do
					spaces.each do |index|
						game.board[index - 1] = "X"
					end
				end

				describe "when the specified player has a winning pattern" do
					it "returns true" do
						expect(game.win?(game.players.last)).to be_true
					end
				end

				describe "when the specified player does not have a winning pattern" do
					it "returns false" do
						expect(game.win?(game.players.first)).to be_false
					end
				end
			end
		end

		context "when the board has a vertical win pattern" do
			patterns = [
				[1, 4, 7],
				[2, 5, 8],
				[3, 6, 9]
			]

			patterns.each do |spaces|
				before do
					spaces.each do |index|
						game.board[index - 1] = "X"
					end
				end

				describe "when the specified player has a winning pattern" do
					it "returns true" do
						expect(game.win?(game.players.last)).to be_true
					end
				end

				describe "when the specified player does not have a winning pattern" do
					it "returns false" do
						expect(game.win?(game.players.first)).to be_false
					end
				end
			end
		end

		context "when the board has a diagonal win pattern" do
			patterns = [
				[1, 5, 9],
				[3, 5, 7]
			]

			patterns.each do |spaces|
				before do
					spaces.each do |index|
						game.board[index - 1] = "X"
					end
				end

				describe "when the specified player has a winning pattern" do
					it "returns true" do
						expect(game.win?(game.players.last)).to be_true
					end
				end

				describe "when the specified player does not have a winning pattern" do
					it "returns false" do
						expect(game.win?(game.players.first)).to be_false
					end
				end
			end
		end
	end

	describe "#over" do
		it "sends the game message 'Game Over' to both players" do
			expect(game).to receive(:send_data).with(:game_message, 'Game Over', game.players)
			game.over
		end
	end

	describe "#annouce_winner" do
		it "sends the result message 'You Win!' to the specified player" do
			expect(game).to receive(:send_data).with(:result_message, 'You Win!', game.players.first)
			game.announce_winner(game.players.first)
		end

		it "sends the result message 'You Lose.' to the player that is not specified" do
			expect(game).to receive(:send_data).with(:result_message, 'You Lose.', game.players.last)
			game.announce_winner(game.players.first)
		end
	end
end