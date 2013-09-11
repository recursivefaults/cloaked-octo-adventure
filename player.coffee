class Parser
    constructor: (@player)->

    parse:(buffer) ->
        string = buffer.toString()
        final = ""
        console.log string
        final = switch
            when string.match(/help/)
                "Not implemented"
            when string.match(/roll/)
                "#{Math.floor(Math.random() * (20 - 1) + 1)}"
            when string.match(/quit/)
                @player.disconnect()
                "Goodbye!"
            else
                "Command not recognized"

        final += "\r\n#{@player.prompt} "

class Creature
    constructor: () ->
        @hd = 0
        @hdMod = 0
        @stats= {str: 0, dex:0, int: 0, con: 0, wis:0, cha:0}
        @saves= {}
        @class = null
    generate: () ->
        for v in @stats
            console.log v
            v = diceRoller("3d6")


class Player
    constructor: (@socket, hash) ->
        console.log "init"
        @prompt = ">"
        @parser = new Parser(@)
        @setupSocket()

    setupSocket: () ->
        @socket.on 'data', (buffer) =>
            @socket.write(@parser.parse(buffer))
    disconnect: () ->
        @socket.close()

exports.Player = Player
exports.Parser = Parser
exports.diceRoller = (expression) ->
    parsed = /(\d+)d(\d+)([+-]\d+){0,1}/.exec expression
    numDice = parsed[1]
    diceSize = parsed[2]
    mod = 0
    if parsed[3]?
        mod = parseInt(parsed[3])
    total = 0
    for i in [0...numDice]
        total += Math.floor(Math.random() * (diceSize - 1) + 1)
    total += mod
    return total
