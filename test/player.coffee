vows = require 'vows'
assert = require 'assert'
player = require '../player'

vows.describe('diceRoller')
    .addBatch(
        'The diceRoller':
            topic: player
            'can roll 1d1': (player) ->
                assert.equal(player.diceRoller('1d1'), 1)
            'can roll 3d6': (player) ->
                value = player.diceRoller('3d6')
                assert(value > 3 and value <= 18)
            'can roll 3d6 (cheating)': (player) ->
                _random = Math.random
                Math.random = () ->
                    return 0.5
                value = player.diceRoller('3d6')
                assert.equal(value, 9)
                Math.random = _random
            'can roll 3d6 (low cheating)': (player) ->
                _random = Math.random
                Math.random = () ->
                    return 0.01
                value = player.diceRoller('3d6')
                assert.equal(value, 3)
                Math.random = _random
            'can roll 3d6 (high cheating)': (player) ->
                _random = Math.random
                Math.random = () ->
                    return 1.0
                value = player.diceRoller('3d6')
                assert.equal(value, 18)
                Math.random = _random
            'can roll 1d1+1': (player) ->
                assert.equal(player.diceRoller('1d1+1'), 2)
            'can roll 1d1-1': (player) ->
                assert.equal(player.diceRoller('1d1-1'), 0)
    ).export(module)

