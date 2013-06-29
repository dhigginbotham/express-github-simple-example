conf = require "../../conf"

scripts = module.exports =
  settings:
    verbose: conf.debug.assets # set this to true to turn on verbosity
    internal: true # this will accept an external array, doesn't work yet... intentions are there.
  items: [
    # {src: '/js/lib/ga.js', name: 'ga.js', where: 'head', uri: null, type: 'js', exclude: null}
    {src: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css', name: 'bootstrap.css', where: 'head', uri: null, type: 'css', exclude: null}
    {src: '//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css', name: 'font-awesome.css', where: 'head', uri: null, type: 'css', exclude: null}
    {src: '/css/style.css', name: 'style.css', where: 'head', uri: null, type: 'css', exclude: null}
    {src: '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js', name: 'jquery.js', where: 'foot', uri: null, type: 'js', exclude: null}
    {src: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js', name: 'bootstrap.js', where: 'foot', uri: null, type: 'js', exclude: null}
    {src: 'http://cdn.sockjs.org/sockjs-0.3.min.js', name: 'sockjs.js', where: 'head', uri: null, type: 'js', exclude: null}
    {src: '/js/vendor/pjax/jquery.pjax.js', name: 'jquery.pjax.js', where: 'foot', uri: null, type: 'js', exclude: null}
    {src: '/js/vendor/prettyprint/prettyprint.js', name: 'prettyprint.js', where: 'foot', uri: null, type: 'js', exclude: null}
    {src: '/js/vendor/prettyprint/prettify.css', name: 'prettify.css', where: 'head', uri: null, type: 'css', exclude: null}
    {src: '/js/app.js', name: 'app.js', where: 'foot', uri: null, type: 'js', exclude: null}
    {src: '/js/vendor/ckedit/contents.css', name: 'contents.css', where: 'foot', uri: '/pages/add', type: 'css', exclude: null}
    {src: '/js/vendor/ckedit/contents.css', name: 'contents.css', where: 'foot', uri: '/pages/:slug/edit', type: 'css', exclude: null}
    {src: '/js/vendor/ckedit/ckeditor.js', name: 'ckeditor.js', where: 'foot', uri: '/pages/:slug/edit', type: 'js', exclude: null}
    {src: '/js/vendor/ckedit/config.js', name: 'config.js', where: 'foot', uri: '/pages/:slug/edit', type: 'js', exclude: null}
    {src: '/js/vendor/ckedit/styles.js', name: 'styles.js', where: 'foot', uri: '/pages/:slug/edit', type: 'js', exclude: null}
    {src: '/js/vendor/ckedit/ckeditor.js', name: 'ckeditor.js', where: 'foot', uri: '/pages/add', type: 'js', exclude: null}
    {src: '/js/vendor/ckedit/config.js', name: 'config.js', where: 'foot', uri: '/pages/add', type: 'js', exclude: null}
    {src: '/js/vendor/ckedit/styles.js', name: 'styles.js', where: 'foot', uri: '/pages/add', type: 'js', exclude: null}
    {src: '/js/pages.client.js', name: 'pages.client.js', where: 'foot', uri: '/pages/:slug/edit', type: 'js', exclude: null}
    {src: '/js/pages.client.js', name: 'pages.client.js', where: 'foot', uri: '/pages/add', type: 'js', exclude: null}
  ]

  logging: (arr, req, fn) ->
    # we're gonna make sure this loads right with some call
    # back fun, should handle this a littler better either way
    len = arr.length
    count = 0

    for a in arr
      do (a) ->
        if a.uri == req.route.path || a.uri  == null
          count++
    process.nextTick () ->
      if fn?
        fn count

  embed: (req, res, next) ->
    # written by david higginbotham, didn't really need to much
    # or something as built out like [connect-assets](https://github.com/adunkman/connect-assets) 
    # so I wrote this little guy to load scripts or css.. I may figure out more
    # ways to extend this in the future, but for now it works
    # and I like it very much for my uses.

    # use this as you wish, maybe buy me a beer one day ;)

    # npm colors module: Thanks to the colors module library
    # i didn't feel the need for a dependency only used for
    # development - so thank you.

    red = '\x1B[31m'
    cyan = '\x1B[36m'
    reset = '\x1B[39m'
    count = 1
    script = scripts.items

    # run a debug log, this should be a constant while in development mode.
    scripts.logging script, req, (count) ->
      console.log "\r\n" if scripts.settings.verbose == true
      console.log "      #{cyan}Included#{reset} #{count} of #{scripts.items.length} #{cyan}files for url:#{reset} [ #{req.url} ]#{reset}" if scripts.settings.verbose == true
      console.log "\r\n" if scripts.settings.verbose == true

    Object.create embed =
      head:
        js: []
        css: []
      foot:
        js: []
        css: []
    
    console.log "\r\n\r\n      #{cyan}[->#{reset} current range: #{req.route.path} #{cyan}<-]#{reset}\r\n\r\n"  if scripts.settings.verbose == true
    
    for ctx in script
      do (ctx) ->
        if (embed.head[ctx.type] || embed.foot[ctx.type]) && ( ctx.uri == req.route.path || ctx.uri == null ) and ctx.exclude != req.route.path
          console.log "      #{red}#{count} - Excluding:#{reset} #{ctx.name}" if ctx.exclude == req.route.path and scripts.settings.verbose is true
          console.log "      #{cyan}#{count} - Including:#{reset} #{ctx.name} into #{ctx.where}er" if scripts.settings.verbose is true
          embed[ctx.where][ctx.type].push ctx
          count++

    process.nextTick () ->
      req.loaded = embed
      next()