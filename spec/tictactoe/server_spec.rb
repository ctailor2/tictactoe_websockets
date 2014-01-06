require 'spec_helper'

describe Server do
	let(:server) { Server.new(double('app')) }
	before do
		2.times do |i|
			server.clients << double("client#{i + 1}").as_null_object
		end
	end

	describe "#new_game_req_met?" do
		context "when there are exactly 2 clients" do
			it "returns true" do
				expect(server.new_game_req_met?).to be_true
			end
		end

		context "when there are not exactly 2 clients" do
			before { server.clients.pop }

			it "returns false" do
				expect(server.new_game_req_met?).to be_false
			end
		end
	end

	describe "#new_game" do
		it "creates a new game with the server's clients" do
			expect(Game).to receive(:new).with(server.clients)
			server.new_game
		end

		it "sets the server's game attribute" do
			expect{server.new_game}.to change{server.game}.from(nil).to(kind_of(Game))
		end
	end
end