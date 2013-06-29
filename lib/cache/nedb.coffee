# require our cache params
DataStore = require "nedb"

conf = require "../../conf"
c = conf.cache()
config = c.cache

# make it real
if config.file == true then ds = new DataStore filename: config.path else ds = new DataStore()

ds.loadDatabase (err) ->
  return new Error err if err?
  if config._verbose == true then console.log "setting up the #{config.type} cache layer"

module.exports = ds 
