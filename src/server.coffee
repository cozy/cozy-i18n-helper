class LocaleManager

    createCozyInstanceSchema: () ->
        Schema = require('jugglingdb').Schema
        settings = url: 'http://localhost:9101/'
        db = new Schema 'cozy-adapter', settings
        CozyInstance = db.define 'CozyInstance', locale: String

    getLocale: (compound, callback) ->

        CozyInstance  = compound?.models?.CozyInstance
        CozyInstance ?= @createCozyInstanceSchema()

        CozyInstance.all (err, instances) ->
            callback(err, instances?[0]?.locale or 'en')

    mount: (compound) ->
        oldListeners = compound.server.listeners('request').splice(0)
        compound.server.removeAllListeners 'request'
        compound.server.on 'request', (req, res) =>
            if req.url is '/cozy-locale.json'
                @getLocale compound, (err, locale) ->
                    res.writeHead 200, 'Content-Type': 'text/json'
                    res.end "{\"locale\":\"#{locale}\"}"
            else
                for listener in oldListeners
                    listener.call compound.server, req, res

    middleware: (req, res, next) =>
        return next() unless req.url is '/cozy-locale.json'

        @getLocale null, (err, locale) ->
            if err then res.send err, 500
            else res.send locale: locale


module.exports = new LocaleManager