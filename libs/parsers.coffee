class ContextualParser
    constructor: (@player) ->
        @isFinished = false
        @nextParser = null
        @output = {output: "Command not recognized", prompt: "\r\n#{@player.prompt}"}

    parse: (input) ->

    setUp: ->

    wrapUp: ->

    buildNextParser: ->
        @nextParser


class LoginParser extends ContextualParser
    constructor: (@player) ->
        @isRegister = false
        super(@player)

    setUp: () ->
        "Welcome to Blah blah blah\r\n
        Would you like to:\r\n
        1) Login\r\n
        2) Register\r\n
        3) Quit\r\n
        \r\n
        >"

    parse: (buffer) ->
        value = parseInt(buffer.toString())
        @output = switch
            when value == 1
                {output: ''}
            when value == 2
                @isRegister = true
                {output: ''}
            when value == 3
                {output: 'Goodbye!', execute: => @player.disconnect}


        
class GeneralParser extends ContextualParser

    parse: (buffer) ->
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

exports.LoginParser = LoginParser
exports.GeneralParser = GeneralParser
