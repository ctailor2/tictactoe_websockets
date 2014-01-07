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
		it "clears the client's status messages" do
			expect(server).to receive(:send_data).with(:status, '', server.clients)
			server.new_game
		end

		it "creates a new game with the server's clients" do
			expect(Game).to receive(:new).with(server.clients)
			server.new_game
		end

		it "sets the server's game attribute" do
			expect{server.new_game}.to change{server.game}.from(nil).to(kind_of(Game))
		end
	end

	describe "#send_data" do
		context "when a single client is specified" do
			it "sends the specified data to the specified client(s)" do
				data_label = :status
				data = 'message for single client'
				client = server.clients.first
				expect(client).to receive(:send).with({ data_label => data }.to_json)
				server.send_data(data_label, data, client)
			end
		end

		context "when a collection of one or more clients is specified" do
			it "sends the specified data to the specified client(s)" do
				data_label = :status
				data = 'message for multiple clients'
				clients = server.clients
				expect(clients.first).to receive(:send).with({ data_label => data }.to_json)
				expect(clients.last).to receive(:send).with({ data_label => data }.to_json)
				server.send_data(data_label, data, clients)
			end
		end
	end
end