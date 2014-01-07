$LOAD_PATH << File.expand_path('./lib')
require 'tictactoe'
require './app'

use Server

run App