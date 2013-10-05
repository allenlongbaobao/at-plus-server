_ = require 'underscore'

message-members = ['mid','type', 'ipid', 'cid', 'originalContentType', 'textContent', 'withinLocation','atUsers', 'createTime','sendBy' 'reposts', 'isCopiedFromThirdPart', 'originUrl', 'permlink']
ip-members = ['type', 'title', 'content', 'createTime', 'withinLocation', 'createdBy', 'isPrivate', 'pictures', 'tags']
location-members = []


check-msg-valid-or-not = !(data, type, callback)->
  switch type
    case 'message'  then members = message-members
    case 'ip'       then members = ip-members
    case 'location' then members = location-members
  difference = _.difference members, _.keys data
  if !_.isEmpty difference 
    callback 'err'
  else
    callback 'not err'


module.exports = 
  check-msg-valid-or-not: check-msg-valid-or-not

