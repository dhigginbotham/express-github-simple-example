cache = require "../cache/crud"
request = require "request"

_ = require "underscore"
### Coderbits API Class Sanitizer ###

Coderbits = (opts) ->
  if typeof opts == "undefined" then opts = {}
  @username = if opts.username? then opts.username else null
  
  return if not @username then new Error "You must define a username for this API"

  @

Coderbits::createPath = () ->
  _default = "https://coderbits.com"
  @path = "#{_default}/#{@username}.json"

Coderbits::request = (options, fn) ->

  if _.isFunction options
    fn = options
    options = {}
  @opts = {}
  @opts.url = if options.url? then options.url else null
  @opts.method = if options.method? then options.method else "GET"

  request @opts, (err, resp, body) ->
    return if err? then fn err, null

    switch resp.statusCode
      when 200 then fn null, body if body
      else fn JSON.stringify err: "Unhandled response code from Coderbits API", code: resp.statusCode, null

HandleResp = (req, options, fn) ->
  
  if _.isFunction options
    fn = options
    options = {}

  coder = new Coderbits username: "dhz"
  coder.createPath()

  cash = new cache req

  # prolly turn this into a switch statement
  cash.page = "/coderbits?#{coder.path}"

  cash.findCache cash.page, (err, cached) ->
    
    return if err? then fn err, null
    
    if cached.length > 0 
      console.log "cache found"
      return fn null, cached[0]

    else 
      console.log "no cache found"
      coder.request url: coder.path, (err, coderbits) ->
        return if err? then fn err, null

        cash.setCache JSON.parse coderbits
        cash.paginate req.query.page || 1

        cash.addCache cash, (err, cached) ->
          return if err? then fn err, null
          return if cached? then fn null, cached

exports.middleware = (req, res, next) ->
  HandleResp req, (err, coder) ->
    return if err? then next err, null
    req.Coderbits = coder
    next()
