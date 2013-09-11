vows = require 'vows'
assert = require 'assert'
world = require '../world'

vows.describe('object')
    .addBatch(
        'An object':
            topic: new world.BaseObject()
            'has a name': (object) ->
                assert.equal(object.name, "Undefined")
            'can describe itself': (object) ->
                assert(object.toString().length > 0)

    ).export(module)

