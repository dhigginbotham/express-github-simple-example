md = require("node-markdown").Markdown

ds = require "../../lib/cache/nedb"
Github = require("../../lib/github").Github
request = require("../../lib/github").request

_ = require "underscore"

middle = {}

middle.dynamic = (req, res, next) ->

  path = req.url

  git = new Github()
  git.apiPath path

  ds.find page: path, (err, cache) ->

    return next err, null if err?

    if cache.length > 0
      console.log "serving cache"
      next null, cache[0]

    else

      console.log "requesting github API"

      git.request (err, github) ->
        return if err? then next err, null
        return if github.err? next github.err, null

        sess = new git.session req, JSON.parse github

        ds.insert sess, (err, github) ->
          return if err? new Error "Session error %s", err
          req.Github = github
          next()

middle.handleFileStream = (req, res, next) ->
  if req.Github? then stream = req.Github.content
  req.GithubStream = stream
  next()

middle.getUserInfo = (req, res, next) ->

  request req, {path: "", user: "dhigginbotham"}, (err, git) ->
    return if err? then next err, null
    req.getUserInfo = git
    return next null, git

middle.getUserRepos = (req, res, next) ->
  
  request req, {path: "/repos", user: req.params.user || "dhigginbotham"}, (err, git) ->
    return if err? then next err, null
    req.getUserRepos = git
    return next null, git

middle.getUserFollowers = (req, res, next) ->
  
  request req, {path: "/followers", user: "dhigginbotham"}, (err, git) ->
    return if err? then next err, null
    req.getUserFollowers = git
    return next null, git

middle.getUserFollowing = (req, res, next) ->
  
  request req, {path: "/following", user: "dhigginbotham"}, (err, git) ->
    return if err? then next err, null
    req.getUserFollowing = git
    return next null, git

middle.getStars = (req, res, next) ->

  request req, {path: "/starred", user: req.params.user || "dhigginbotham"}, (err, git) ->
    return if err? then next err, null
    req.getStars = git
    return next null, git

middle.getCache = (req, res, next) ->
  ds.find {}, (err, cache) ->
    return if err? then next err, null
    req.gitCache = cache if cache? 
    next null, cache

middle.removeCache = (req, res, next) ->
  ds.remove _id: req.body.remove, (err) ->
    return if err? then next err, null
    next()

middle.scan = (req, res, next) ->

  request req, {path: req.url, user: false}, (err, git) ->
    return if err? then next err, null

    template = []
    for key, val of git.cache
      template.push {name: key, amount: val, repo: git.page}

    req.scan = template
    console.log req.scan
    return next null, git

module.exports = middle