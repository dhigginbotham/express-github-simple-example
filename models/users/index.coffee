conf = require "../../conf"
helpers = require "../../conf/helpers"

supergoose = require "supergoose"

Schema = require("mongoose").Schema
ObjectId = Schema.Types.ObjectId

bcrypt = require "bcrypt"
SALT_WORK_FACTOR = 10

UserSchema = new Schema
  email: String
  username:
    type: String
    unique: true
    required: true
  password: String
  admin: 
    type: Boolean
    default: false
  type:
    type: String
    default: "user"
  first_name: String
  last_name: String
  zip: String
  phone: String
  location: Object
  geoLocation: String
  created: 
    type: Date
    default: Date.now
  last_login:
    type: Date
    default: Date.now
  source: String
  ip: String
  _extended: Object

UserSchema.pre "save", (next) ->
  self = @

  if !self.isModified "password"
    return next()
  else
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
      if err
        return next(err)
      bcrypt.hash self.password, salt, (err, hash) ->
        if err
          return next(err)
        else
          self.password = hash
          return next()
          
UserSchema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, this.password, (err, isMatch) ->
    if err
      return cb(err)
    cb null, isMatch

UserSchema.plugin supergoose
User = module.exports = db.model "User", UserSchema

if conf.seed.init == true
  col = new conf.colors()
  db.once "open", () ->

    User.findOne username: "admin", (err, seed) ->
      return console.log err if err?
      if !seed
        admin = new User
          username: "admin"
          password: conf.seed.password
          admin: true # still using this
          role: "admin"
          email: "admin@localhost.it"
          ip: "admin.ipv6"

        admin.save (err) ->
          return err if err
      else
        console.log "!!! - #{col.red}User exists#{col.reset} - you can find this setting in './conf/index.coffee' - !!!"