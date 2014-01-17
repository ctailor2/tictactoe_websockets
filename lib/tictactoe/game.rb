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
			if win?
				announce_winner(players.last)
				over
			elsif draw?
				announce_draw
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

	def win?
		patterns = rows + cols + diags

		patterns.any? do |pattern|
			pattern.uniq.length == 1 && pattern.uniq.first != nil
		end
	end

	def rows
		rows = []
		board.each_slice(3) do |row|
			rows << row
		end
		rows
	end

	def cols
		rows.transpose
	end

	def diags
		[board.values_at(2, 4, 6), board.values_at(0, 4, 8)]
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

	def draw?
		board.all?
	end

	def announce_draw
		send_data(:player_message, 'Draw.', players)
	end
end