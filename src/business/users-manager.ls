require! './database'
_ = require 'underscore'

get-brief-users-map = !(uids, current-uid, callback)->
  (db) <-! database.get-db
  uids.push current-uid
  (err, users) <-! db.at-plus.users.find {_id: "$in": uids} .to-array
  callback create-brief-users-map users, current-uid

create-brief-users-map = (users, current-uid)->
  current-user = get-user-by-id users, current-uid
  brief-users-map = {}
  for user in users
    if user._id is current-uid 
      brief-users-map[user._id] =  create-brief-current-user user
    else 
      brief-users-map[user._id] = create-brief-user user
      brief-users-map[user._id].is-my-friend = true if user._id in current-user.friends
      brief-users-map[user._id].is-followed-by-me = true if user._id in current-user.follows
  brief-users-map

create-brief-current-user = (user)->
  _id: user._id
  is-current-user: true

create-brief-user = (user)->
  _id: user._id
  name: user.username
  avatar: user.avatars[0]

create-brief-user-from-uid = (uid, callback)->
  (db) <-! database.get-db
  (err, users) <-! db.at-plus.users.find {_id: uid} .to-array
  callback create-brief-user users[0]

get-user-by-id = !(users, id)->
  for user in users
    return user if user._id is id

module.exports =
  get-brief-users-map: get-brief-users-map
  create-brief-user-from-uid: create-brief-user-from-uid
  create-brief-users-map: create-brief-users-map # !!暴露出来，仅仅是为了测试