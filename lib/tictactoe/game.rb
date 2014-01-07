class Game
	attr_reader :players

	def initialize(clients)
		@players = clients
		turn!
		show
	end

	def turn!
		send_data(:turn_message, 'Your Turn', players.first)
		send_data(:turn_message, "Opponent's Turn", players.last)
		players.rotate!
	end

	def show
		send_data(:display_message, 'show', players)
	end

	def send_data(label, data, *players)
		players.flatten.each do |player|
			player.send({ label => data }.to_json)
		end
	end
end