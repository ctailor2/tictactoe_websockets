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
        clients << ws
        case num_clients
        when 1
          send_data(:status, 'Waiting for Challenger', ws)
        when 2
          new_game
        else
          send_data(:status, 'Game in Progress - Please try again later.', ws)
        end
      end

      ws.on :message do |event|
        game.receive_data(event.data)
      end

      ws.on :close do |event|
      	p [:close, ws.object_id, event.code, event.reason]
      	clients.delete(ws)
      	ws = nil
      end

      ws.rack_response
		else
			@app.call(env)
		end
	end

  def num_clients
    clients.length
  end

  def new_game
    send_data(:status, '', clients)
    self.game = Game.new(clients)
  end

  def send_data(data_label, data, *clients)
    clients.flatten.each do |client|
      client.send({ data_label => data }.to_json)
    end
  end
end