express = require "express"
app = module.exports = express()

conf = require "../../conf"

passport = require "passport"
util = require "util"

FacebookStrategy = require("passport-facebook").Strategy

# `User` Schema, required anywhere you find db calls
User = require "../../models/users"

# passport.serializeUser (user, done) ->
#   done null, user

# passport.deserializeUser (obj, done) ->
#   done null, obj

passport.use new FacebookStrategy
  clientID: conf.pass.fb.id
  clientSecret: conf.pass.fb.secret
  callbackURL: "#{conf.pass.redirectUrl}#{conf.pass.fb.route}"
  scope: "email, user_location, user_likes, publish_actions"
  (accessToken, refreshToken, profile, done) ->
    User.findOne username: profile._json.username, (err, user) ->
      if err? then done err, null
      if user
        updateUser =
          last_login: new Date profile._json.updated_time
          token: accessToken
        User.update username: profile._json.username, updateUser, (err) ->
          if err
            return done err, null

          process.nextTick () ->
            return done null, user
      else
        user = new User
          username: profile._json.username
          token: accessToken
          first_name: profile._json.first_name
          last_name: profile._json.last_name
          email: profile._json.email
          location: profile._json.location
          role: "facebook"
        
        user.save (err, newUser) ->
          if err
            return done err, null
          if newUser
            return done null, newUser          
