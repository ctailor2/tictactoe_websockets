class Game
	attr_reader :players

	def initialize(clients)
		@players = clients
		turn!
	end

	def turn!
		players.first.send({ :turn_message => 'Your Turn' }.to_json)
		players.last.send({ :turn_message => "Opponent's Turn" }.to_json)
		players.rotate!
	end
end