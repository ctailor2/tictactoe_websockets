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
	end

	describe "#players" do
		it "is a collection of Player objects" do
			expect(game.players.all? { |player| player.is_a?(Player) }).to be_true
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

			it "sends a marker message containing the sender's space number and marker to both players" do
				expect(game).to receive(:send_data).with(:marker_message, [2, game.players.last.marker], game.players)
				game.receive_data(data)
			end

			it "completes the turn" do
				expect(game).to receive(:turn!)
				game.receive_data(data)
			end
		end
	end
end