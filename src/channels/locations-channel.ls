require! ['./locations-manager', './interesting-points-manager', './channel-initial-wrapper', './config']
# _ = require 'underscore'
business = require './event-bus'


request-initial-handler = !(socket, data, callback)->
  (resolved-locations, inexistence-locations-urls) <-! locations-manager.resolve-locations data.locations
  (interesting-points-summaries) <-! interesting-points-manager.get-interesting-points-summaries [location._id for location in resolved-locations]
  join-locations-rooms socket, resolved-locations
  join-inexsitence-locations-rooms socket, inexistence-locations-urls # 一旦对应url有兴趣点创建（形成location），就能够收到消息
  callback err = null, get-response-initial-data resolved-locations, interesting-points-summaries

join-locations-rooms = !(socket, locations)->
  for location in locations
    socket.join location._id
    debug "socket: #{socket.id} join #{location._id}"

join-inexsitence-locations-rooms =!(socket, inexistence-locations-urls)->
  for url in inexistence-locations-urls
    socket.join get-room url
    debug "socket: #{socket.id} join #{room}"

get-room = (inexistence-location-url)->
  # add prefix to url for distinguishing from location id
  config.locations-channel.inexistence-prefix + inexistence-location-url

get-response-initial-data = (locations, interesting-points-summaries)->
  locations.for-each !(location)->
    location.interesting-points-summaries = interesting-points-summaries[location._id]

  locations: locations

module.exports  = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      request-initial-handler: !(socket, data, callback)->
        callback!

      response-initial-handler: request-initial-handler

      business-handlers-register: !(socket, data, callback)->
        # ----- 以下响应来自客户端的请求 ---------------- #
        socket.on 'request-update-location', !(data)->
          <-! locations-manager.update-location data.lid, data.update
          socket.broadcast.to(data.lid).emit 'response-update-location', data
          # debug 'response-update-location emitted at: ', data.lid

        # socket.on 'leave-location'

          


        callback err = null, {
        }
        
    }

