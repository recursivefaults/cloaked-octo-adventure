utility = require './utility'
parsers = require './parsers'

class Creature
    constructor: (hash) ->
        @pId = hash?._id || null
        @hd = hash?.hd || 0
        @hdMod = hash?.hdMod || 0
        @stats = hash?.stats || {str: 0, dex:0, int: 0, con: 0, wis:0, cha:0}
        @saves = {}
        @class = null
        @ac = hash?.ac || 10
        @thac0 = hash?.thac0 || 10
        @name = hash?.name || "Unnamed"
    generate: () ->
        for k, v of @stats
            @stats[k] = utility.diceRoller("3d6")
        @hp = utility.diceRoller("#{@hd}d8+#{@hdMod}")


class Monster extends Creature
    constructor: (hash) ->
        @xp = hash?.xp || 0
        super(hash)
    toString: () ->
        "#{@name}\r\n
        #{@description? || ''}\r\n
        HP: #{@hp}\r\n
        HD: #{@hd} + #{@hdMod}\r\n
        AC: #{@ac}\r\n\r\n"

class Player
    constructor: (@socket, @room) ->
        @name = "The Player"
        @prompt = ">"
        @parser = new parsers.LoginParser(@)
        @setupSocket()
        @creature = null

    setupSocket: () ->
        @writeString(@parser.setUp()) if !@parser.isSetup
        @socket.on 'data', (buffer) =>
            results = @parser.parse(buffer)
            console.log results
            @writeString(results.output + results.prompt)
            results.execute?()
    writeString: (string) ->
        @socket.write(string)

    switchParser: (parser) ->
        @parser.wrapUp()
        @parser = parser
        @writeString(@parser.setUp())

    disconnect: () ->
        @socket.end()
    toString: () ->
        "The Player\r\n"

exports.Player = Player
exports.Monster = Monster
