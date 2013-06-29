
### BadRequestError ###
# handles bad requests with custom messages, borrowed from passport.js (local) thanks!
# 
#  `message` - error message string
BadRequestError = (message) ->
  Error.call @
  Error.captureStackTrace @, arguments.callee
  @name = "Oops"
  @message = message || null

BadRequestError::__proto__ = Error::

module.exports = BadRequestError