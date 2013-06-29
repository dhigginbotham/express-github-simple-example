User = require "../../models/users"

_users = module.exports =
  Update: (req, res, next) ->

    if req.route.path == "/users/:user/edit"
      query = req.params.user
    else
      query = req.user.username

    if req.body.is_editor?
      role = "editor"
      admin = true

    if req.body.is_admin?
      role = "admin"
      admin = true

    if !req.body.verifiedTxtMsg
      verifiedTxtMsg = false
    else
      verifiedTxtMsg = true

    user =
      ip: req.ip
      first_name: req.body.first_name
      last_name: req.body.last_name
      email: req.body.email
      zip: req.body.zip
      phone: req.body.phone
      verifiedTxtMsg: verifiedTxtMsg
      role: role
      admin: admin

    User.update username: query, user, (err) ->
      if err
        req.flash "info", type: "error", title: "Oh Snap!", msg: "wasn't able to update"
        next()
      else
        req.flash "info", type: "success", title: "Sweet!", msg: "You've been updated"
        next()

  Create: (req, res, next) ->
    
    if req.body.is_editor?
      role = "editor"
      admin = true

    if req.body.is_admin?
      role = "admin"
      admin = true
      
    if !req.body.verifiedTxtMsg
      verifiedTxtMsg = false
    else
      verifiedTxtMsg = true

    user = new User
      username: req.body.username        
      ip: req.ip     
      first_name: req.body.first_name        
      last_name: req.body.last_name
      email: req.body.email
      zip: req.body.zip
      phone: req.body.phone
      password: req.body.password
      verifiedTxtMsg: verifiedTxtMsg
      role: role
      admin: admin

    user.save (err, user) ->
      if err
        req.flash "info", type: "error", title: "Oh Snap!", msg: "wasn't able to create"
        next()
      if user
        req.flash "info", type: "success", title: "Sweet!", msg: "You've been updated"
        next()

  checkExists: (req, callback) ->

    if req.body && req.params.id

      User.findOne(email: req.body.email).exec (err, user) ->
        console.log user
        if err
          callback "nothing found...", null
        if user
          callback null, user
        else
          callback null, null
    else
      console.log "me here 4"
      callback "nothing found... try again", null

  addUser: (req, callback) ->
    
    if req.body && req.params.id

      if !req.body.email_optin
        verifiedTxtMsg = false
      else
        verifiedTxtMsg = true

      if !req.body.email_optin
        emailOptin = false
      else
        emailOptin = true

      user = new User
        username: req.body.email
        ip: req.ip
        first_name: req.body.first_name
        last_name: req.body.last_name
        email: req.body.email
        emailOptin: req.body.emailOptin
        zip: req.body.zip
        phone: req.body.phone
        verifiedTxtMsg: verifiedTxtMsg
        source: req.url

      user.save (err, savedUser) ->
        if err
          callback "nothing found...", null
        if user
          callback null, savedUser
        else
          callback "no users found...", null
    else
      callback "nothing found... try again", null    

  updateUser: (req, callback) ->
    if req.body && req.params.id
      if !req.body.email_optin
        verifiedTxtMsg = false
      else
        verifiedTxtMsg = true

      if !req.body.email_optin
        emailOptin = false
      else
        emailOptin = true

      user = Object.create
        username: req.body.email
        ip: req.ip
        first_name: req.body.first_name     
        last_name: req.body.last_name
        email: req.body.email
        emailOptin: req.body.emailOptin
        zip: req.body.zip
        phone: req.body.phone
        verifiedTxtMsg: verifiedTxtMsg
        source: req.url

      User.update email: req.body.email, user, {safe: true}, (err, updatedUser) ->
        if err
          callback "nothing found...", null
        if user
          callback null, updatedUser
        else
          callback "no users found...", null
    else
      callback "nothing found... try again", null

  findAddUpdate: (req, res, next) ->
    dHandler.checkExists req, (err, user) ->
      if err
        next err, null
      if !user
        dHandler.addUser req, (err, addedUser) ->
          req._user = addedUser
      else
        dHandler.updateUser req, (err, updatedUser) ->
          req._user = updatedUser
      process.nextTick () ->
        req._user = user
        next()

  userPaging: (req, res, next) ->
    sort = {created: -1}

    User
      .find({})
      .sort(sort)
      .paginate {page: req.params.page, perPage: 20}, (err, users) ->
        if err
          req.flash "info", type: "error", title: "Oh Snap!", msg: "wasn't able to find any users"
          next()
        else
          req._users = users
          next()