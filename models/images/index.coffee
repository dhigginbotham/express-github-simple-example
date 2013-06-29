string = require "../../conf/helpers"
path = require "path"
supergoose = require "supergoose"

Schema = require("mongoose").Schema
ObjectId = Schema.Types.ObjectId

TagSchema = new Schema
  name: String

ImageSchema = new Schema
  _id: ObjectId
  title: String
  ts: 
    type: Date
    default: Date.now
  unique: String
  name: String
  type: String
  lastModifiedDate: Date
  path: String
  size: String
  published: 
    type: Boolean
    default: false
  tags: [TagSchema]
  who: 
    type: String
    ref: "User"

ImageSchema.plugin supergoose
Image = module.exports = db.model "Image", ImageSchema

# ImageSchema.statics.process = processImg = (image) ->
#   image['tags-count'] = image.tags.length
#   image['created-date'] = moment(new Date(image.ts)).fromNow()
#   image['image-id'] = image._id

# ImageSchema.statics.processImgs = (images) ->
#   images.forEach processImg

# ImageSchema.pre "save", (next) ->
#   next()