User = require "../../models/users"

users = module.exports =
  get:
    login: (req, res) ->
      delete req.session.originalUrl # fix this...
      if req.user
        res.redirect "/"
      else
        res.render "pages/users/login",
          title: "Login Page"
          flash: req.flash "info"
          que: req.loaded
          nav: req._navObj

    register: (req, res) ->
      res.render "pages/register",
        title: "Register Page"
        flash: req.flash "info"
        submit: "Register"
        que: req.loaded
        nav: req._navObj

    logout: (req, res) ->
      req.logout()
      delete req.user
      res.redirect "/login"

    make: (req, res) ->
      res.render "pages/users/register",
        title: "Make an account"
        flash: req.flash "info"
        user: req.user
        submit: "Create User"
        que: req.loaded
        nav: req._navObj

    json: (req, res) ->
      User.find {}, password: 0, _id: 0, __v: 0, created: 0, (err, docs) ->
        return err if err
        return res.json(docs) if docs

    view: (req, res) ->

      res.render "pages/view",
        title: "View Users"
        user: req.user
        users: req._users
        prefix: "users"
        flash: req.flash "info"
        json_link: "/api/users/view"
        page_heading: "<i class='icon-user'></i> View all users"
        que: req.loaded
        nav: req._navObj

    remove: (req, res) ->
      User.remove username: req.params.user, (err) ->
          return err if err
          res.redirect "back"

    edit: (req, res) ->
      User.find username: req.params.user, (err, docs) ->
        return err if err
        res.render "pages/users/register",
          title: "Edit account"
          flash: req.flash "info"
          user: req.user
          submit: "Save Changes"
          que: req.loaded
          nav: req._navObj
          edit: docs

    userEdit: (req, res) ->
      User.find username: req.user.username, (err, docs) ->
        return err if err
        res.render "pages/users/register",
          title: "Manage your account"
          flash: req.flash "info"
          user: req.user
          submit: "Update Account"
          que: req.loaded
          nav: req._navObj
          edit: docs

  # post routes, see middleware for whats happening 
  post:
    register: (req, res) ->
      res.redirect "/"

    make: (req, res) ->
      res.redirect "/users/view"    

    edit: (req, res) ->
      res.redirect "back"

    userEdit: (req, res) ->
      res.redirect "back"
