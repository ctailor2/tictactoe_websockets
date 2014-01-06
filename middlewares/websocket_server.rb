require 'faye/websocket'
require 'json'

class Server
	KEEPALIVE_TIME = 15 # in seconds
  attr_reader :clients
  attr_accessor :game

	def initialize(app)
		@app = app
		@clients = []
    @game = nil
	end

	def call(env)
		if Faye::WebSocket.websocket?(env)
			ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
      ws.on :open do |event|
        p [:open, ws.object_id]
        @clients << ws
        data = {:num_clients => @clients.length}
        ws.send(data.to_json)
        new_game if new_game_req_met?
      end

      ws.on :message do |event|
      	p [:message, event.data]
      	@clients.each { |client| client.send(event.data) }
      end

      ws.on :close do |event|
      	p [:close, ws.object_id, event.code, event.reason]
      	@clients.delete(ws)
      	ws = nil
      end

      ws.rack_response
		else
			@app.call(env)
		end
	end

  def new_game_req_met?
    clients.length == 2
  end

  def new_game
    self.game = Game.new(clients)
  end
end