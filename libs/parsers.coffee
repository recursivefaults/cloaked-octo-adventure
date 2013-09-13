model = require './model'

class ContextualParser
    constructor: (@player) ->
        @isFinished = false
        @initialized = false
        @nextParser = null
        @output = {output: "Command not recognized", prompt: "\r\n#{@player.prompt}"}

    parse: (input) ->

    setUp: ->
        @initialized = true
        ""

    wrapUp: ->
        ""



class LoginParser extends ContextualParser
    constructor: (@player) ->
        super(@player)
        ###
        # Ok, status is how we know what the parser should do
        # 
        # 0 : Main menu
        # 1 : Login (Username)
        # 2 : Login (Password)
        # 3: Register
        ###
        @status = 0


    setUp: () ->
        super()
        "Welcome to Blah blah blah\r\n
        Would you like to:\r\n
        1) Login\r\n
        2) Register\r\n
        3) Quit\r\n
        \r\n
        >"

    parse: (buffer) ->
        users = new model.SimpleModel('users')
        value = parseInt(buffer.toString())
        output = @output
        output = switch
            when value == 1 and @status == 0
                @status = 1
                {output: 'Enter your registered email address: ', prompt: ""}
            when value == 2 and @status == 0
                @isRegister = true
                {output: ''}
            when value == 3 and @status == 0
                {output: 'Goodbye!', execute: => @player.disconnect}
            when @status == 1
                @status = 2
                users.findOne({email: buffer.toString}, (err, result) =>
                    throw err if err
                    console.log result
                    @tempUser = result if result?
                )
                {output: "Password: ", prompt: ""}
            when @status == 2
                ## Hash that mess up.
                @isFinished = true
                {output: "Welcome!", execute: => @player.switchParser(new GeneralParser(@player))}
        output


        
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
