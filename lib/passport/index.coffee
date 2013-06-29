passport = require "passport"
LocalStrategy = require("passport-local").Strategy

VERBOSE = if process.env.NODE_ENV == "development" then false

User = require "../../models/users"
# passport.serializeUser (user, done) ->
#   done null, user

# passport.deserializeUser (obj, done) ->
#   done null, obj

passport.serializeUser (user, done) ->
  done null, user._id

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    done err, user

passport.use new LocalStrategy (username, password, done) ->
  User.findOne username: new RegExp(username, 'i'), (err, user) ->
    return done err if err
    return done null, false, message: "Unknown user " + username if !user
    user.comparePassword password, (err, isMatch) ->
      return done err if err
      if isMatch
        return done null, user 
      else 
        done null, false, message: "Invalid Password"

exports.ensureAuthenticated = ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.redirect "/"
    return req.flash "info", type: "info", title: "Whoops!", msg: "You must be logged in for that.."

exports.ensureAdmin = ensureAdmin = (req, res, next) ->
  if req.user.role == "admin" || req.user.admin == true
    next() 
  else 
    res.redirect "/"
    return req.flash "info", type: "info", title: "Whoops!", msg: "You must be logged in for that.."

exports.ensureEditor = ensureEditor = (req, res, next) ->
  if req.user.role == "editor" 
    next() 
  else 
    res.redirect "/"
    return req.flash "info", type: "info", title: "Whoops!", msg: "You must be logged in for that.."
