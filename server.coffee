net = require 'net'
player = require './player'
world = require './world'

players = []

theRoom = new world.Room({name: "Test Grounds", description: "This is how we see things happen"})

server = net.createServer (socket) ->
    monster = new player.Monster({name: "Test Monster"})
    monster.generate()
    theRoom.addItem(monster)
    players.push(new player.Player(socket))
    socket.write(theRoom.toString())
    theRoom.addItem(player)

server.listen 1337, '127.0.0.1'

