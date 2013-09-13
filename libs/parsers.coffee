model = require './model'
crypto = require 'crypto'

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
                {output: '', execute: => @player.switchParser(new RegistrationParser))}
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
                hash = crypto.createHash('sha256')
                pHash = hash.digest(buffer.toString())
                console.log @tempUser
                if !@tempUser? or @tempUser.password != pHash
                    console.log "Invalid credentials"
                    {output: "Invalid credentials, sorry\r\n", prompt:"Password: "}
                else
                    {output: "Welcome!", execute: => @player.switchParser(new GeneralParser(@player))}
            else
                @output
        output

class RegistrationParser extends Contextualparser
    constructor:(@player) ->
        super(@player)
        @status = 0
        @userObject = {}
    setUp: () ->
        super()
        "Enter your email address: "

    parse: (buffer) ->
        users = new model.SimpleModel('users')
        input = buffer.toString()
        output = @output
        switch @state
            when 0
                #Is the email taken
                @userObject.email = input
                users.findOne(email: input, (err, result) =>
                    if result?
                        output.output = "Sorry, that address is taken"
                    else
                        @state += 1
                        output.output = "Password: "
                        
                )

                output.prompt = ""
                @state += 1
            when 1
                @userObject.password = input
                


        output

        
class GeneralParser extends ContextualParser
    setUp: () ->
        super()
        @player.room.toString()

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
