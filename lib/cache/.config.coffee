fs = require "fs"
path = require "path"

int = require "../../conf"

config = (options) ->

  # make `options` a conditional object so that we don't need to call it 
  # unless we want to override options
  if typeof options == "undefined" then options = {}

  # define our type of cache to use
  #   accepts `['nedb', 'cookie', 'session', 'moretbd']`
  @type = if options.type? then options.type else "nedb"

  # decide to use a in memory store or a persistant file store
  @file = if options.file? then options.file else true

  # define our path, unless overwritten
  _path = if not options.path? then path.join __dirname, "db", "static.nedb.db" 
  @path = if options.path? then options.path else "./lib/cache/db/static.nedb.db"

  ### Configure Session & Cookie Defaults ###
  @session = if options.session? then options.session else {}
  @session.secret = if @session.secret? then @session.secret else process.env.NODE_PASS || "some-1337-passw0rd-yo"
  @session.key = if @session.key? then @session.key else "#{@type}.sid"

  _sessionPath = if not options.path? then path.join __dirname, "db", "session.nedb.db" 
  @session.filename = if @session.filename? then @session.filename else "./lib/cache/db/session.nedb.db"

  @db = if options.db? then options.db else {}
  @db.mongoUrl = if @db.mongoUrl? then @db.mongoUrl else int.db.mongoUrl
  @db.interval = if @db.interval? then @db.interval else 1200000

  @cookie = if options.cookie? then options.cookie else {}
  @cookie.path = if @cookie.path? then @cookie.path else "/"
  @cookie.httpOnly = if @cookie.httpOnly? then @cookie.httpOnly else true
  @cookie.maxAge = if @cookie.maxAge? then @cookie.maxAge else 365 * 24 * 3600 * 1000

  @_verbose = int.debug.cache
  
  @

module.exports = new config()