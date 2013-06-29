md = require("node-markdown").Markdown

routes = {}

routes.github = (req, res) ->
  res.render "pages/github",
  title: "Github Page"
  nav: req._navObj
  flash: req.flash "info"
  que: req.loaded
  user: req.user
  gitTables: req.getStars || req.getUserRepos || req.getUsersRepos
  gitUser: req.getUserInfo

routes.follow = (req, res) ->
  res.render "pages/github/follow",
  title: "Follow Page"
  nav: req._navObj
  flash: req.flash "info"
  que: req.loaded
  user: req.user
  gitView: req.getUserFollowers || req.getUserFollowing
  gitUser: req.getUserInfo

module.exports = routes