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
			expect(game).to receive(:send_data).with(:player_message, 'Your Turn', first_player)
			game.turn!
		end

		it "sends the message 'Opponent's Turn' to the second player" do
			second_player = game.players.last
			expect(game).to receive(:send_data).with(:player_message, "Opponent's Turn", second_player)
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

	describe "#fill_space" do
		let(:space_number) { 2 }

		it "checks if the space number is occupied" do
			expect(game).to receive(:occupied?).with(2)
			game.fill_space(space_number)
		end

		context "when the space number is unoccupied" do
			it "fills in the board space with the sender's marker" do
				game.fill_space(space_number)
				expect(game.board[1]).to eq("X")
			end

			it "sends a marker message containing the sender's space number and marker to both players" do
				expect(game).to receive(:send_data).with(:marker_message, [2, game.players.last.marker], game.players)
				game.fill_space(space_number)
			end

			describe "when it results in a win condition" do
				before do
					spaces = [5, 8]
					spaces.each do |space|
						game.board[space - 1] = "X"
					end
				end

				it "does not complete the turn" do
					expect(game).not_to receive(:turn!)
					game.fill_space(space_number)
				end

				it "announces the winner" do
					expect(game).to receive(:announce_winner).with(game.players.last)
					game.fill_space(space_number)
				end

				it "makes the game over" do
					expect(game).to receive(:over)
					game.fill_space(space_number)
				end
			end

			describe "when it results in a draw condition" do
				before do
					x_spaces = [1, 6, 7, 8]
					x_spaces.each do |space|
						game.board[space - 1] = "X"
					end

					o_spaces = [5, 3, 4, 9]
					o_spaces.each do |space|
						game.board[space - 1] = "O"
					end
				end

				it "does not complete the turn" do
					expect(game).not_to receive(:turn!)
					game.fill_space(space_number)
				end

				it "announces the draw" do
					expect(game).to receive(:announce_draw).with(no_args())
					game.fill_space(space_number)
				end

				it "makes the game over" do
					expect(game).to receive(:over)
					game.fill_space(space_number)
				end
			end

			describe "when it does not result in either a win or draw condition" do
				it "completes the turn" do
					expect(game).to receive(:turn!)
					game.fill_space(space_number)
				end

				it "does not announce the winner" do
					expect(game).not_to receive(:announce_winner).with(game.players.last)
					game.fill_space(space_number)
				end

				it "does not make the game over" do
					expect(game).not_to receive(:over)
					game.fill_space(space_number)
				end
			end
		end

		context "when the space number is occupied" do
			before do
				game.board[1] = "O"
			end

			it "does not fill in the board space with the sender's marker" do
				game.fill_space(space_number)
				expect(game.board[1]).not_to eq("X")
			end

			it "does not send a marker message containing the sender's space number and marker to both players" do
				expect(game).not_to receive(:send_data).with(:marker_message, [2, game.players.last.marker], game.players)
				game.fill_space(space_number)
			end

			it "does not complete the turn" do
				expect(game).not_to receive(:turn!)
				game.fill_space(space_number)
			end
		end
	end

	describe "#win?" do
		context "when the board has no win patterns" do
			it "returns false" do
				expect(game.win?).to be_false
			end
		end

		context "when the board has a horizontal win pattern" do
			patterns = [
				[1, 2, 3],
				[4, 5, 6],
				[7, 8, 9]
			]

			patterns.each_with_index do |pattern, index|
				before do
					pattern.each do |space|
						game.board[space - 1] = "X"
					end
				end

				describe "in row #{index + 1}" do
					it "returns true" do
						expect(game.win?).to be_true
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

			patterns.each_with_index do |pattern, index|
				before do
					pattern.each do |space|
						game.board[space - 1] = "X"
					end
				end

				describe "in column #{index + 1}" do
					it "returns true" do
						expect(game.win?).to be_true
					end
				end
			end
		end

		context "when the board has a diagonal win pattern" do
			patterns = [
				[1, 5, 9],
				[3, 5, 7]
			]

			patterns.each_with_index do |pattern, index|
				before do
					pattern.each do |space|
						game.board[space - 1] = "X"
					end
				end

				describe "for pattern #{index + 1}" do
					it "returns true" do
						expect(game.win?).to be_true
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

		it "disconnects" do
			expect(game).to receive(:disconnect)
			game.over
		end
	end

	describe "#annouce_winner" do
		it "sends the result message 'You Win!' to the specified player" do
			expect(game).to receive(:send_data).with(:player_message, 'You Win!', game.players.first)
			game.announce_winner(game.players.first)
		end

		it "sends the result message 'You Lose.' to the player that is not specified" do
			expect(game).to receive(:send_data).with(:player_message, 'You Lose.', game.players.last)
			game.announce_winner(game.players.first)
		end
	end

	describe "#occupied?" do
		before { game.board[4] = "X" }

		context "when the specified space number is occupied" do
			it "returns true" do
				expect(game.occupied?(5)).to be_true
			end
		end

		context "when the specified space number is unoccupied" do
			it "returns false" do
				expect(game.occupied?(9)).to be_false
			end
		end
	end

	describe "#receive_data" do
		let(:data) { "{\"marker_message\":2}" }

		it "fills the correct space" do
			expect(game).to receive(:fill_space).with(2)
			game.receive_data(data)
		end
	end

	describe "#rows" do
		before do
			[1, 4, 7].each do |space|
				game.board[space - 1] = "X"
			end
		end

		it "returns the rows of the board" do
			expect(game.rows).to eq([["X", nil, nil], ["X", nil, nil], ["X", nil, nil]])
		end
	end

	describe "#cols" do
		before do
			[1, 2, 3].each do |space|
				game.board[space - 1] = "X"
			end
		end

		it "returns the columns of the board" do
			expect(game.cols).to eq([["X", nil, nil], ["X", nil, nil], ["X", nil, nil]])
		end
	end

	describe "#diags" do
		before do
			[1, 3, 7, 9].each do |space|
				game.board[space - 1] = "X"
			end
		end

		it "returns the diagonals of the board" do
			expect(game.diags).to eq([["X", nil, "X"], ["X", nil, "X"]])
		end
	end

	describe "#draw?" do
		before do
			x_spaces = [1, 6, 7, 8]
			x_spaces.each do |space|
				game.board[space - 1] = "X"
			end

			o_spaces = [5, 3, 4, 9]
			o_spaces.each do |space|
				game.board[space - 1] = "O"
			end
		end

		context "when the board is not full" do
			it "returns false" do
				expect(game.draw?).to be_false
			end
		end

		context "when the board is full" do
			before do
				space = 2
				game.board[space - 1] = "X"
			end

			it "returns true" do
				expect(game.draw?).to be_true
			end
		end
	end

	describe "#announce_draw" do
		it "sends the result message 'Draw.' to both players" do
			expect(game).to receive(:send_data).with(:player_message, 'Draw.', game.players)
			game.announce_draw
		end
	end

	describe "#disconnect" do
		it "disconnects each player" do
			expect(game.players.first).to receive(:disconnect)
			expect(game.players.last).to receive(:disconnect)
			game.disconnect
		end
	end
end