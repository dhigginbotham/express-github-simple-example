form = require "express-form"
filter = form.filter
validate = form.validate

_validate = module.exports =
  add:
    form(
      filter("pages_title").trim()
      validate("pages_title").required()
      validate("pages_content").required()
    )
