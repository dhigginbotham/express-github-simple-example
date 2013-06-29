routes = {}

routes.homePage = (req, res) ->
  res.render "pages/home",
  title: "Login Page"
  nav: req._navObj
  flash: req.flash "info"
  que: req.loaded
  user: req.user
  github: req.Github

module.exports = routes