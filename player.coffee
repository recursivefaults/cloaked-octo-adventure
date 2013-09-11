class Parser
    constructor: (@player)->

    parse:(buffer) ->
        string = buffer.toString()
        final = {}
        console.log string
        final = switch 
            when string.match(/help/)
                {output: "Not implemented"}
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
            @stats[k] = diceRoller("3d6")
        console.log "Generate"
        console.log @stats

class Monster extends Creature
    constructor: (hash) ->
        @xp = hash?.xp || 0
        super(hash)



class Player
    constructor: (@socket, hash) ->
        console.log "init"
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

diceRoller = (expression) ->
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
exports.Player = Player
exports.Monster = Monster
exports.Parser = Parser
exports.diceRoller = diceRoller
