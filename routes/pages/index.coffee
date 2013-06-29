express = require "express"
app = module.exports = express()
flash = require "connect-flash"

fs = require "fs"
path = require "path"

middle = require "./middleware"
routes = require "./routes"
valid = require "./validate"

pass = require "../../lib/passport"
passport = require "passport"

scripts = require "../../lib/assets"
nav = require "../../lib/menus"
conf = require "../../conf"

_views = path.join __dirname, "..", "..", "views"

app.set "views", _views
app.set "view engine", "mmm"
app.set "layout", "layout"

# app.all "/pages/*", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render

# pages routes for basic cms stuff
app.get "/pages/view", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, middle.findAll, routes.view
app.get "/pages/add", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, routes.add
app.post "/pages/add", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, valid.add, middle.addPage, routes.add
app.get "/pages/:slug/edit", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, middle.findOne, routes.edit
app.post "/pages/:slug/edit", middle.editPage, (req, res) ->
  res.redirect req.get "Referer"
app.get "/pages/:slug", pass.ensureAuthenticated, pass.ensureAdmin, scripts.embed, nav.render, middle.findOne, routes.single
