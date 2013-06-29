### Global SockJS Routes ###
sockjs = require "sockjs"

### Attach SockJS to the Server ###
exports.install = (opts, server) ->

  # here's an example of how to add an additional listener

  #   ### SockJS - questions  listener ###
  #   # questions gets latest pending questions

  #   sockjs_questions = sockjs.createServer opts
  #   # initialize our .on event listeners
  
  #   sockjs_questions.on "connection", (conn) ->
  #     # pass console.log to client side
  
  #     conn.on "close", ->
  #       # pass console.log to client side
  
  #     conn.on "data", (m) ->
  #       # server side in here..  
  #       # make stuff happen here!
  
  #       conn.write m

  ###  Install Handlers for Sock JS  ###
  # add additional handlers with a unique `prefix` route like so:

  #     sockjs_echo.installHandlers server,
  #        prefix: "/echo"

  ### SockJS - ECHO  listener ###
  # default echo, passes a string to and from the server
  # easy to configure
  sockjs_echo = sockjs.createServer opts
  # initialize our .on event listeners
  sockjs_echo.on "connection", (conn) ->
    # pass console.log to client side
    conn.on "close", ->
      # pass console.log to client side
    conn.on "data", (m) ->
      console.log m
      # server side in here..  
      # make stuff happen here!
      conn.write m

  # install handler to `sockjs_echo`
  sockjs_echo.installHandlers server, prefix: "/echo"

