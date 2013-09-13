vows = require 'vows'
assert = require 'assert'
parsers = require '../libs/parsers'

player = {
    disconnect: ->

    prompt: ">"
}

class MockBuffer
    constructor: (@string) ->

    toString: () ->
        "#{@string}"

vows.describe("The Login Parser")
    .addBatch(
        'A login parser':
            topic: new parsers.LoginParser(player)
            'can parse 1,2,3' : (parser) ->
                assert.doesNotThrow -> 
                    parser.parse(new MockBuffer("1"))
                    
            "can't parse 'a'": (parser) ->
                
                assert.doesNotThrow -> 
                    parser.parse(new MockBuffer("a"))

    ).export(module)
