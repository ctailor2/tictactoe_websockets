require 'spec_helper'

describe Player do
	let(:player) do
		client = double('client')
		Player.new(client, 'X')
	end
	
	describe "#initialize" do
		it "should respond to #client" do
			expect(player).to respond_to(:client)
		end

		it "should respond to #marker" do
			expect(player).to respond_to(:marker)
		end
	end

	describe "#marker" do
		context "when initialized with marker 'X'" do
			it "returns 'X'" do
				expect(player.marker).to eq("X")
			end
		end
	end
end