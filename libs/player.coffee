utility = require './utility'
class Parser
    constructor: (@player)->

    parse:(buffer) ->
        string = buffer.toString()
        final = {}
        console.log string
        final = switch 
            when string.match(/help/)
                {output: "Not implemented"}
            when string.match(/(look|ex|examine) (\w+)/)
                results = string.match(/(look|ex|examine) (.+)/)
                console.log results
                lookedAt = results[2]
                target = @player.room.find(lookedAt)
                {output: target?.toString() || "Sorry, look at what?"}
            when string.match(/(look|ex|examine)/)
                {output: target?.toString() || "Sorry, look at what?"}
            when string.match(/quit/)
                {output: "Goodbye!", execute: => @player.disconnect()}
            else
                {output: "Command not recognized"}

        final.output += "\r\n#{@player.prompt} "
        final

class Creature
    constructor: (hash) ->
        @hd = hash?.hd || 0
        @hdMod = hash?.hdMod || 0
        @stats = hash?.stats || {str: 0, dex:0, int: 0, con: 0, wis:0, cha:0}
        @saves = {}
        @class = null
        @ac = hash?.ac || 10
        @thac0 = hash?.thack0 || 10
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
        @parser = new Parser(@)
        @setupSocket()

    setupSocket: () ->
        @socket.on 'data', (buffer) =>
            results = @parser.parse(buffer)
            console.log results
            @socket.write(results.output)
            results.execute?()

    disconnect: () ->
        @socket.end()
    toString: () ->
        "The Player\r\n"

exports.Player = Player
exports.Monster = Monster
exports.Parser = Parser
