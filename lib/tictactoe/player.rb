class Player
	attr_reader :client, :marker

	def initialize(client, marker)
		@client = client
		@marker = marker
	end

	def disconnect
		client.close
	end
end