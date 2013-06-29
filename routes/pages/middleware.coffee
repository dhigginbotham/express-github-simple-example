Page = require "../../models/pages"
###
  PageSchema = new Schema
    _id: String
    title: String
    ts: 
      type: Date
      default: Date.now
    content: String
    published: 
      type: Boolean
      default: true
    notes: [Notes]
    who: 
      type: String
      ref: "User"
###
_page = module.exports =
  addPage: (req, res, next) ->
    if req.body? && req.body.page_title?
      page = new Page
        title: req.body.page_title
        content: req.body.pages_content
        who: req.user._id
        slug: req.body.page_slug
      page.save (err, page) ->
        if err?
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if page?
          req.flash "info", type: "success", title: "Awesome", msg: "You made a page!"
          req._page = page
          next()
        else
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error creating your page"
          next()        
  editPage: (req, res, next) ->
    if req.body? && req.body.page_title?

      if req.body.published? && req.body.published == "on"
        published = true
      else
        published = true

      page =
        slug: req.body.page_slug
        title: req.body.page_title
        content: req.body.pages_content
        who: req.user._id
        published: published

      Page.update slug: req.params.slug, page, safe: true, (err, page) ->
        if err?
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if page?
          req.flash "info", type: "success", title: "Awesome", msg: "You made a page!"
          req._page = page
          next()
  findOne: (req, res, next) ->
    Page.findOne slug: req.params.slug, (err, page) ->
      if err
        req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
        next()
      if page
        req._page = page
        next()
      else
        req.flash "info", type: "error", title: "Oh Snap!", msg: "No page found... sorry, try again."
        next()
  findAll: (req, res, next) ->
    Page.find (err, page) ->
        if err
          req.flash "info", type: "error", title: "Oh Snap!", msg: "There was an error!"
          next()
        if page
          req._page = page
          next()
        else
          req.flash "info", type: "error", title: "Oh Snap!", msg: "No pages found... sorry, try again."
          next()
  pagesPagination: (req, res, next) ->
    sort = {created: -1}

    Page
      .find({})
      .sort(sort)
      .paginate {page: req.params.page, perPage: 25}, (err, pages) ->
        if err
          req.flash "info", type: "error", title: "Oh Snap!", msg: "wasn't able to find any pages"
          next()
        else
          req._page = pages
          next()