require! ['./users-manager', './channel-initial-wrapper', './utils']

module.exports  = 

  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of '/users'

      request-initial-handler: !(socket, data, callback)->
        utils.fake-load-uid socket, data.uid
        callback!

      response-initial-handler: !(socket, data, callback)->
        (friends-list) <-! users-manager.get-all-friends-of-a-user socket.session.uid
        callback err = null, friends-list: friends-list

      business-handlers-register: !(socket, data, callback)->
        callback err = null, {}
        
    }

