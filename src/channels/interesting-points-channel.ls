# 文档和协议设计见：http://my.ss.sysu.edu.cn/wiki/display/AFWD/Locations+Channel+Protocol

require! [ './config', './channel-initial-wrapper', './locations-manager', './users-manager', './interesting-points-manager', './message-valid-judge-helper', './mock-config'.mock-server, './mock-interesting-points']
_ = require 'underscore'
event-bus = require './event-bus'

replace-user-id-with-breif-user = !(obj, uid-attr-name, callback)->
  (user) <-! users-manager.create-brief-user-from-uid obj[uid-attr-name]
  obj[uid-attr-name] = user
  callback!

get-push-ip-updated-message = (data)->
  type: "new-msg-added"
  _id: data._id
  added-msg: data.message

message-valid-judge = !(data, type, callback)->
  (result) <-! message-valid-judge-helper.check-msg-valid-or-not data, type
  if result == 'err'
    callback 'err'
  else 
    callback!

module.exports  = 
  init: !(io)->
    # ------------------- 以下响应服务端business层的请求----------------#
    event-bus.on 'interesting-points-channel:ip-updated', !(data)~>
      if io.sockets.sockets[data.session-id]
        debug "-------in: 'interesting-points-channel: ip-updated' ------socket:", io.sockets.sockets[data.session-id].id
        debug "------------broadcase: 'push-ip-updated'"
        io.of('/interesting-points').sockets[data.session-id].broadcast.to(data._id).emit 'push-ip-updated', get-push-ip-updated-message data

    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/interesting-points')

      business-handlers-register: !(socket, data, callback)->
        
        # ----- 以下响应来自客户端的请求 ---------------- #
        socket.on 'request-create-a-new-ip-on-a-new-url', !(data, emit-callback-fn)->
          debug "------ in: 'request-create-a-new-ip-on-a-new-url', socket.id: ---------", socket.id
          debug "------ in: 'message valid judge'--------"
          (result) <-! message-valid-judge data, 'ip'
          if result == 'err'
            emit-callback-fn 'err'
          else
            if mock-server.ips.create-a-new-ip-on-a-new-url is false
              (result) <-! mock-interesting-points.mock-create-a-new-ip-on-a-new-url data
            else
              (location) <-! locations-manager.create-or-update-a-location socket.id, 
                url: data.within-location.url
                name: data.within-location.name
              (interesting-point-summary) <-! interesting-points-manager.create-interesting-point location, data
              <-! replace-user-id-with-breif-user interesting-point-summary, 'createdBy'
              debug "------ emit: 'response-create-a-new-ip-on-a-new-url' ---------"
              emit-callback-fn { 
                result: 'success'
                lid: location._id
                ipid: interesting-point-summary._id
              }
              locations-manager.update-location-with-ip socket.id, data.within-location.url, location, interesting-point-summary

        socket.on 'request-send-a-new-message-on-an-ip', !(data)->
          (reslut) <-! message-valid-judge data, 'message'
          if reslut == 'err'
            socket.emit 'message-have-an-err', 'err' 
          else
            (location) <-! locations-manager.create-or-update-a-location socket.id,
              url: data.within-location.url
              name: data.within-location.name
            (result) <-! interesting-points-manager.send-message location, data
            socket.emit 'response-send-a-new-message-on-an-ip', 
              result: 'success'
              ipid: result.ipid
              mid: result.mid
            interesting-points-manager.update-ip-with-msg socket.id, data.within-location.urls, data


        callback!
        
    }

