routes = {}

routes.coderbits = (req, res) ->
  res.render "pages/coderbits",
  title: "Coderbits Page"
  nav: req._navObj
  flash: req.flash "info"
  que: req.loaded
  user: req.user
  coderbits: req.Coderbits
  
module.exports = routes