require 'spec_helper'

describe Game do
	let(:game) do
		clients = []
		2.times do |i|
			clients << double("client#{i + 1}").as_null_object
		end
		Game.new(clients)
	end

	describe "#initialize" do
		it "responds to #players" do
			expect(game).to respond_to(:players)
		end
	end

	describe "#turn!" do
		it "sends the message 'Your Turn' to the first player" do
			data = { :turn_message => 'Your Turn' }
			expect(game.players.first).to receive(:send).with(data.to_json)
			game.turn!
		end

		it "sends the message 'Opponent's Turn' to the second player" do
			data = { :turn_message => "Opponent's Turn" }
			expect(game.players.last).to receive(:send).with(data.to_json)
			game.turn!
		end

		it "rotates the players" do
			expect(game.players).to receive(:rotate!)
			game.turn!
		end
	end

	describe "#show" do
		it "sends the display message 'Show' to both players" do
			data = { :display_message => 'show' }
			expect(game.players.first).to receive(:send).with(data.to_json)
			expect(game.players.last).to receive(:send).with(data.to_json)
			game.show
		end
	end

	describe "#send_data" do
		context "when a single player is specified" do
			it "sends the specified data to the specified player(s)" do
				label = :data_label
				data = 'message for single player'
				player = game.players.first
				expect(player).to receive(:send).with({ label => data }.to_json)
				game.send_data(label, data, player)
			end
		end

		context "when a collection of players is specified" do
			it "sends the specified data to the specified player(s)" do
				label = :data_label
				data = 'message for multiple players'
				players = game.players
				expect(players.first).to receive(:send).with({ label => data }.to_json)
				expect(players.last).to receive(:send).with({ label => data }.to_json)
				game.send_data(label, data, players)
			end
		end
	end
end