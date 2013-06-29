ds = require "./nedb"
request = require "request"
_ = require "underscore"

helpers = require "../../conf/helpers"
conf = require "../../conf"

cache = (req, opts) ->

  if typeof opts == "undefined" then opts = {}

  @stale = if opts.stale? then opts.stale else 600
  @page = if opts.page? then opts.page else req.url

  @

cache::setCache = (cache) ->
  @cache = cache

cache::paginate = (page) ->
  @paginate = new helpers.paginate page

cache::findCache = (page, fn) ->
  ds.find page: page, (err, cache) ->
    return if err? fn err, null
    console.log "found cache for #{page}"
    fn null, cache if cache?

cache::addCache = (cache, fn) ->
  ds.insert cache, (err, cache) ->
    return if err? fn err, null
    console.log "inserting cache for #{cache.page}"
    fn null, cache if cache?

cache::removeCache = (id, fn) ->
  ds.remove _id: id, (err) ->
    return if err? fn err, null
    console.log "removing cache for #{id}"
    fn null, "removed"

module.exports = cache