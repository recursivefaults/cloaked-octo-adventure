net = require 'net'
player = require './player'

players = []

server = net.createServer (socket) ->
    socket.write "Echo server \r\n"
    players.push(new player.Player(socket))

server.listen 1337, '127.0.0.1'

