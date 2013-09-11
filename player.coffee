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
