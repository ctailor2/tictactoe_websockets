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
end