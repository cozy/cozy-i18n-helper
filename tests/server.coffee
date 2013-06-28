express = require 'express'
expect = require('chai').expect
http = require 'http'
Client = require('request-json').JsonClient
initializer = require '../src/server.coffee'

Schema = require('jugglingdb').Schema
settings = url: 'http://localhost:9101/'
db = new Schema 'cozy-adapter', settings
CozyInstance = db.define 'CozyInstance', locale: String

describe 'Serve client file (Express)', ->

    before (done) ->
        CozyInstance.requestDestroy 'all', done

    before (done) ->
        CozyInstance.create {locale: 'ja'}, (err, instance) =>
            console.log err if err
            @instanceid = instance.id
            done(err)

    before (done) ->

        app = express()

        app.use initializer.middleware

        app.get '/test', (req, res) -> res.send 'hey'

        @server = http.createServer app

        port = process.env.PORT or 6666
        host = process.env.HOST or "127.0.0.1"

        @client = new Client "http://#{host}:#{port}/"

        @server.listen port, host, done

    after (done) ->
       CozyInstance.requestDestroy 'all', done

    it 'should let request go', (done) ->
        @client.get 'test', (err, res, body) ->
            expect(body).to.equal 'hey'
            done()

    it 'should serve client under its url', (done) ->
        @client.get 'cozy-locale.json', (err, res, body) ->
            expect(err).to.be.null
            expect(body.locale).to.equal 'ja'
            done()