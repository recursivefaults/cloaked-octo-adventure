mongo = require('mongodb')

class SimpleModel
    constructor: (@cName, @host='localhost', @port=27017, @dbName = "wod") ->
        @db = null

    findOne: (query, callback) ->
        @getCollection (err, collection) =>
            @close(err, callback) if err
            collection.findOne(query, (err, result) =>
                callback(err, null) if err
                callback(null, result)
                @close()
            )

    getCollection: (callback) ->
        mongo.MongoClient.connect("mongodb://#{@host}:#{@port}/#{@dbName}", (err, db) =>
            callback(err, null) if err
            @db = db
            callback(null, @db.collection(@cName))
        )

    close: (err, callback) ->
        console.log "Error in mongo #{err}" if err
        @db.close()
        callback(err, null) if err


exports.SimpleModel = SimpleModel
