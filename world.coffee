event = require('events')
class BaseObject extends event.EventEmitter
    constructor: (hash) ->
        @name = hash?.name || "Undefined"
        @description = hash?.description || "Undefined"
        @contents = []
        super()
    addItem: (object) ->
        @contents.push(object)
    removeItem: (object) ->
        @contents.slice(@contents.indexOf(object), 1)
        
    toString: () ->
        string = "#{@name}\r\n\r\n#{@description}\r\n"
        for item in @contents
            string += "#{item.name}\r\n"
        string
    
class Room extends BaseObject
    constructor: (hash) ->
        @connections = {}
        super(hash)

    up: () ->
        @connections.up
    down: () ->
        @connections.down
    east: () ->
        @connections.east
    west: () ->
        @connections.west
    north: () ->
        @connections.north
    south: () ->
        @connections.south

exports.BaseObject = BaseObject
exports.Room = Room
