class Parser
    constructor: (@player)->

    parse:(buffer) ->
        string = buffer.toString()
        final = ""
        console.log string
        final = switch 
            when string.match(/help/) 
                "Not implemented"
            else 
                "Command not recognized"

        final += "\r\n"




class Player
    constructor: (@socket, hash) ->
        console.log "init"
        @parser = new Parser(@)
        @setupSocket()

    setupSocket: () ->
        @socket.on 'data', (buffer) =>
            @socket.write(@parser.parse(buffer))

exports.Player = Player
