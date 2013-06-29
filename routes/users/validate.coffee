form = require "express-form"
filter = form.filter
validate = form.validate


validation = module.exports =
  register:
    form(
      filter("username").trim()
      validate("username").required().is(/^[a-zA-Z0-9]+$/)
      filter("password").trim()
      validate("password").required().is(/^[a-zA-Z0-9]+$/)
      filter("email").trim()
      validate("email").required().isEmail()
    )