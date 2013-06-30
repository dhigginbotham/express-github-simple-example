express = require "express"
app = module.exports = express()
flash = require "connect-flash"

fs = require "fs"
path = require "path"

routes = require "./routes"

scripts = require "../assets"
nav = require "../menus"
conf = require "../../conf"

_views = path.join __dirname, "..", "..", "views"

app.set "views", _views
app.set "view engine", "mmm"
app.set "layout", "layout"

coderbits = require "./index"

# default or home route
app.get "/coderbits", (req, res) ->
  return res.redirect "/coderbits/profile"

app.get "/coderbits/profile", nav.render, scripts.embed, coderbits.middleware, routes.coderbits
