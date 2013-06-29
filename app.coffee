### Express Image Gallery w/ API ###
conf = require "./conf"
# get this party started
express = require "express"
flash = require "connect-flash"
# get this party started

sockjs = require "sockjs"
sockjs_conf = require "./lib/sockjs/config"
sockjs_app = require "./lib/sockjs/routes"

app = express()
server = require("http").createServer app

sockjs_app.install sockjs_conf.server_opts, server

# global connection sharing
require "./models/db"

# native modules
fs = require "fs"
path = require "path"

passport = require "passport"
_passport = require "./lib/passport"

# init required folders
initPath = path.join __dirname, "public", "uploads"
init = require("./conf/helpers").init initPath

# routes, middleware, etc etc
home = require "./routes/home"
users = require "./routes/users"
pages = require "./routes/pages"
github = require "./routes/github"
coderbits = require "./lib/coderbits/app"

cache = require "./lib/cache"

_views = path.join __dirname, "views"

restify = require "express-restify-mongoose"

User = require "./models/users"

# default application configuration
app.set "port", process.env.port || 80
app.use express.logger "dev"
app.use express.compress()
app.use express.errorHandler()

if process.env.NODE_ENV == "development"
  app.set "port", conf.app.port
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true
app.use express.favicon()

app.use express.methodOverride()
app.use express.bodyParser 
  keepExtensions: true

app.use express.static path.join __dirname, "public"

restify.serve app, User,
  prefix: "/api"

app.use cache

app.use passport.initialize()
app.use passport.session()

app.use flash()

# playing with app.router i don't see much of a use
# when using express as a modular app stack
# app.use app.router

#app.use on our routes.
app.use home
app.use users
app.use pages
app.use "/github", github
app.use coderbits
# app.use (req, res) ->
#   res.status 404
#   res.render "pages/404", 
#     title: "404: File Not Found"
# app.use (err, req, res, next) ->
#   res.status 500
#   res.render "pages/404", 
#     title: "500: Internal Server Error"
#     err: err

# go!
server.listen app.get("port"), () ->
  col = conf.colors()
  console.log "#{col.cyan}::#{col.reset} starting engine #{col.cyan}::#{col.reset} #{conf.app.welcome} #{col.cyan}::#{col.reset} "

# cluster(server)
#   .set('workers', 4)
#   .use(cluster.debug())
#   .listen(conf.app.port);

process.on "SIGINT", () ->
  db.close()
  server.close()
  process.exit()
