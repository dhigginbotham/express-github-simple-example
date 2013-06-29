NavLoader = module.exports =
  types:
    auth: [
      {std : null, id : 'welcome', icon : 'home', cur : null, href : '/', token : null}
      {std : 'Repos', id : 'view-repos', icon : 'code', cur : null, href : '/github/repos', token : null}
      {std : 'Starred Repos', id : 'view-starred', icon : 'star', cur : null, href : '/github/starred', token : null}
      {std : 'Logout', id : 'logout', icon : null, cur : null, href : '/logout', token : null}
    ]

    noauth: [
      {std : null, id : 'home', icon : 'home', cur : null, href : '/', token : null}
      {std : 'Repos', id : 'view-repos', icon : 'code', cur : null, href : '/github/repos', token : null}
      {std : 'Starred Repos', id : 'view-starred', icon : 'star', cur : null, href : '/github/starred', token : null}
      {std : 'Login', id : 'login', icon : null, cur : null, href : '/login', token : null}
    ]

    admin: [
      {std : null, id : 'welcome', icon : 'home', cur : null, href : '/', token : null}
      {std : 'View Pages', id : 'view-pages', icon : null, cur : null, href : '/pages/view', token : null}
      {std : 'Add Page', id : 'add-pages', icon : null, cur : null, href : '/pages/add', token : null}
      {std : 'Repos', id : 'view-repos', icon : 'code', cur : null, href : '/github/repos', token : null}
      {std : 'Starred Repos', id : 'view-starred', icon : 'star', cur : null, href : '/github/starred', token : null}
      {std : 'Logout', id : 'logout', icon : null, cur : null, href : '/logout', token : null}
    ]
  
  render: (req, res, next) ->
    if !req.user
      nav = NavLoader.types.noauth
    else if req.user.admin is true
      nav = NavLoader.types.admin
    else
      nav = NavLoader.types.auth

    for n in nav
      do (n) ->
        if req.url == n.href then n.cur = "active" else n.cur = null

    req._navObj = nav
    next()
