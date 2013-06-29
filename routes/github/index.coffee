express = require "express"
app = module.exports = express()
flash = require "connect-flash"

fs = require "fs"
path = require "path"

mid = require "./middleware"
middle = new mid("dhigginbotham")
routes = require "./routes"

scripts = require "../../lib/assets"
nav = require "../../lib/menus"
conf = require "../../conf"

github = require "../../lib/github"

_views = path.join __dirname, "..", "..", "views"

app.set "views", _views
app.set "view engine", "mmm"
app.set "layout", "layout"

# default or home route
app.get "/", (req, res) ->
  return res.redirect "/github/starred"
app.get "/starred", nav.render, scripts.embed, middle.getStars, middle.getUserInfo, routes.github

app.get "/repos", nav.render, scripts.embed, middle.getUserInfo, middle.getUserRepos, routes.github
app.get "/repos/:user", nav.render, scripts.embed, middle.getUserInfo, middle.getUsersRepos, routes.github
app.get "/followers", nav.render, scripts.embed, middle.getUserInfo, middle.getUserFollowers, routes.follow
app.get "/following", nav.render, scripts.embed, middle.getUserInfo, middle.getUserFollowing, routes.follow
