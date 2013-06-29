express = require "express"

# initialize nedb store
#NedbStore = require("connect-nedb-session")(express);

# initialize our mongodb dev session store
SessionStore = require("session-mongoose")(express)

app = module.exports = express()

conf = require "../../conf"
c = conf.cache()
config = c.cache

# or you can use the individual
#config = require "./config"

console.log config if config._verbose == true

app.use express.cookieParser()

# SESSION STORE THROUGH NEDB
# app.use express.session
#   secret: config.session.secret
#   key: config.session.key
#   cookie: config.cookie
#   store: new NedbStore filename: config.session.filename

# SESSION STORE THROUGH MONGODB
# app.use express.session
#   store: new SessionStore config.db
#   secret: config.session.secret
#   key: config.session.key
#   cookie: maxAge: config.cookie.maxAge

# SESSION STORE THROUGH COOKIES
app.use express.cookieSession
  key: conf.cookie.key
  secret: conf.cookie.secret
  cookie: maxAge: conf.cookie.maxAge

ds = require "./nedb"