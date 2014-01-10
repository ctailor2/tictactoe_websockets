class Game
	attr_reader :players, :board

	def initialize(clients)
		@players = []
		players << Player.new(clients.first, 'X')
		players << Player.new(clients.last, 'O')
		@board = Array.new(9)
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
			player.client.send({ label => data }.to_json)
		end
	end

	def receive_data(data)
		parsed_data = JSON.parse(data, :symbolize_names => true)
		space_number = parsed_data[:marker_message]
		# Current turn is of last player because turn! method rotates players
		if board[space_number - 1].nil?
			board[space_number - 1] = players.last.marker
			send_data(:marker_message, [space_number, players.last.marker], players)
			turn!
		end
	end
end