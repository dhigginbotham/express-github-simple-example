fs = require "fs"
path = require "path"
mkdirp = require "mkdirp"
util = require "util"
_ = require "underscore"

red = '\x1B[31m'
cyan = '\x1B[36m'
reset = '\x1B[39m'

trim = (str) -> str.replace(/^\s\s*/, '').replace /\s\s*$/, ''

stripVowelAccent = (str) ->
  s = str

  rExps = [
    /[\xC0-\xC4]/g, /[\xE0-\xE5]/g,
    /[\xC8-\xCB]/g, /[\xE8-\xEB]/g,
    /[\xCC-\xCF]/g, /[\xEC-\xEF]/g,
    /[\xD2-\xD6]/g, /[\xF2-\xF6]/g,
    /[\xD9-\xDC]/g, /[\xF9-\xFC]/g
  ]

  repChar = [ 'A', 'a', 'E', 'e', 'I', 'i', 'O', 'o', 'U', 'u' ]

  for i in [0..rExps.length]
    s = s.replace rExps[i], repChar[i]

  return s

slugify = (str) ->
  stripped = stripVowelAccent str
  return stripped.replace(/[^A-Za-z0-9 ]/g, "").replace(/[ ]+/g, "-").toLowerCase().substr 0, 81

uniqueId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

matchImg = (String) ->
  String.match /\.(jpe?g|gif|png)$/gi

paginate = (page) ->
  current = if _.isNumber page then page else parseInt page

  @isFirst = if current <= 1 then true else false
  @current = if current < 2 then 1 else current
  @previous = if current - 1 > 1 then current - 1 else 1
  @next = @current + 1

makeUploadsFolder =
  exists: (err, folder, fn) ->
    fs.exists folder, (exists) ->
      if !exists
        fn null, folder if fn?
      else
        fn "folder exists", null
  make: (err, folder, fn) ->
    if folder != null
      mkdirp folder, (err) ->
        fn err, null if err
        fn null, folder
    else
      fn "folder is null", null
  init: (folder) ->
    makeUploadsFolder.exists null, folder, (err, data) ->
      makeUploadsFolder.make null, data, (err, added) ->
        if added != null
          console.log "#{cyan}Creating:#{reset} #{added}"

module.exports =
  trim: trim
  slugify: slugify
  uniqueId: uniqueId
  matchImg: matchImg
  init: makeUploadsFolder.init
  paginate: paginate
