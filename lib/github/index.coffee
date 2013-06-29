request = require "request"
_ = require "underscore"

helpers = require "../../conf/helpers"
conf = require "../../conf"
ds = require "../cache/nedb"

### Surf github API ###
Github = (opts) ->
  
  # allow for opts to be passed through conditionally
  if typeof opts == "undefined" then opts = {}
  
  # pass through an api token, or use the default
  @access_token = if opts.access_token? then opts.access_token else conf.github.token
  @path = if opts.url? then opts.url else "https://api.github.com"

  return if not @access_token? then new Error "You must have a valid Github OAuth Token to use this API"

  @
### setUser ###
# this allows you to set the api path to `/users/:username`
Github::setUser = (user, oauth) ->

  @user = user
  @path += "/users/#{@user}"

  if oauth == true
    @OAuth()

### OAuth ###
# github oauth param `access_token`
Github::OAuth = ->

  oath = "?access_token=#{@access_token}"
  @path += oath

### apiPath ###
# set a custom path for the api
Github::apiPath = (path) ->

  @path += path

Github::paging = (page) ->
  @path += "?page=#{page}"

### request ###
# uses [request](https://github.com/mikael/request)
Github::request = (options, fn) ->
  
  if _.isFunction options
    fn = options
    options = {}

  options.url = if options.url? then options.url else @path
  options.headers = if options.headers? then options.headers else "User-Agent": "#{@user}-surfing"
  options.method = if options.method? then options.method else "GET"

  request options, (err, resp, body) ->
    return if err? then fn err, null

    switch resp.statusCode
      when 200 then fn null, body if body
      else fn JSON.stringify err: "Unhandled response code from Github API", code: resp.statusCode, null







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

getResponse = (req, options, fn) ->
  
  if _.isFunction options
    fn = options
    options = {}

  git = new Github()
  git.setUser (if options.user? then options.user else conf.github.username), false
  git.apiPath if options.path? then options.path else ""
  git.paging req.query.page || 1

  __cache = new cache req

  # prolly turn this into a switch statement
  if options.path == "" then __cache.page = "/user"

  __cache.findCache __cache.page, (err, cached) ->
    
    return if err? then fn err, null
    
    if cached.length > 0 
      console.log "cache found"
      return fn null, cached[0]

    else 
      console.log "no cache found"
      git.request url: git.path, (err, github) ->
        return if err? then fn err, null

        __cache.setCache JSON.parse github
        __cache.paginate req.query.page || 1

        __cache.addCache __cache, (err, cached) ->
          return if err? then fn err, null
          return if cached? then fn null, cached

exports.Github = Github
exports.request = getResponse