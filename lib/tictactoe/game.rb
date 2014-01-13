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
		send_data(:player_message, 'Your Turn', players.first)
		send_data(:player_message, "Opponent's Turn", players.last)
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

	def fill_space(space_number)
		# Current turn is of last player because turn! method rotates players
		unless occupied?(space_number)
			board[space_number - 1] = players.last.marker
			send_data(:marker_message, [space_number, players.last.marker], players)
			if win?(players.last)
				announce_winner(players.last)
				over
			else
				turn!
			end
		end
	end

	def receive_data(data)
		parsed_data = JSON.parse(data, :symbolize_names => true)
		space_number = parsed_data[:marker_message]
		fill_space(space_number)
	end

	def win?(player)
		marker = player.marker
		results = []
		rows = []
		board.each_slice(3) do |row|
			rows << row
		end
		cols = rows.transpose
		diags = [board.values_at(2, 4, 6), board.values_at(0, 4, 8)]
		patterns = rows + cols + diags

		patterns.each do |pattern|
			results << pattern.all? { |pattern_marker| pattern_marker == marker }
		end

		results.any?
	end

	def over
		send_data(:game_message, 'Game Over', players)
	end

	def announce_winner(player)
		winner = player
		loser = players.reject { |player| player == winner }.first
		send_data(:player_message, 'You Win!', winner)
		send_data(:player_message, 'You Lose.', loser)
	end

	def occupied?(space_number)
		!board[space_number - 1].nil?
	end
end