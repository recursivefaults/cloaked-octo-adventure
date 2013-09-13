net = require 'net'
player = require './libs/player'
world = require './libs/world'
mongo = require 'mongodb'

players = []

theRoom = new world.Room({name: "Test Grounds", description: "This is how we see things happen"})

server = net.createServer (socket) ->
    monster = new player.Monster
        name: "Test Monster"
        description: "It's the first thing we've ever had!"
        hd: 4
        ac: 11
        thac0: 11
    monster.generate()
    theRoom.addItem(monster)
    players.push(new player.Player(socket, theRoom))
    socket.write(theRoom.toString())
    theRoom.addItem(player)

server.listen 1337, '127.0.0.1'

