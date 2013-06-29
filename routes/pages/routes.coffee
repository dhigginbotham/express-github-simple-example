_page = module.exports =
  add: (req, res) ->
    res.render "pages/pages/add",
      user: req.user
      flash: req.flash "info"
      nav: req._navObj
      que: req.loaded
  edit: (req, res) ->
    res.render "pages/pages/add",
      user: req.user
      edit: req._page
      flash: req.flash "info"
      nav: req._navObj
      que: req.loaded
  view: (req, res) ->
    res.render "pages/pages/view",
      user: req.user
      pages: req._page
      flash: req.flash "info"
      que: req.loaded
      nav: req._navObj
      prefix: "pages"
  single: (req, res) ->
    res.render "pages/pages/single",
      user: req.user
      pages: req._page
      flash: req.flash "info"
      que: req.loaded
      nav: req._navObj
      prefix: "pages"
