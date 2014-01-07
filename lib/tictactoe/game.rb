class Game
	attr_reader :players

	def initialize(clients)
		@players = clients
		turn!
		show
	end

	def turn!
		players.first.send({ :turn_message => 'Your Turn' }.to_json)
		players.last.send({ :turn_message => "Opponent's Turn" }.to_json)
		players.rotate!
	end

	def show
		players.each do |player|
			player.send({ :display_message => 'show' }.to_json)
		end
	end
end