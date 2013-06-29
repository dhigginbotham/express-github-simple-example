routes = {}

routes.github = (req, res) ->
  res.render "pages/github",
  title: "Github Page"
  nav: req._navObj
  flash: req.flash "info"
  que: req.loaded
  user: req.user
  gitTables: req.getStars || req.getUserRepos || req.getUsersRepos
  gitScan: req.scan || false
  gitUser: req.getUserInfo

routes.scan = (req, res) ->
  res.render "pages/github/tags",
  title: "Github Page"
  nav: req._navObj
  flash: req.flash "info"
  que: req.loaded
  user: req.user
  gitScan: req.scan || false
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

routes.admin = (req, res) ->
  res.render "pages/github/admin",
  title: "Follow Page"
  nav: req._navObj
  flash: req.flash "info"
  que: req.loaded
  user: req.user
  gitUser: req.getUserInfo
  gitCache: req.gitCache

module.exports = routes