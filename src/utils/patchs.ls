require! './session-store'

module.exports =
  patch-socket-with-accross-namespaces-session: !->
    Socket = require 'socket.io/lib/socket.js'


    Socket.prototype.on = !(event, listener)->
      new-listener = !->
        debug " capture #{event} at #{@.id} the session is: ", @session
        #request-data = 
        #  | !arguments[0] or typeof! arguments[0] is 'Function' => {}
        #  | otherwise => arguments[0]
        #if event-need-to-be-verified event and (verify-result = scheme-manager.verify-result-data event, request-data).result is 'failed'
        #  emit-callback-fn = arguments[*-1]
        #  if typrof! emit-callback-fn isnt 'Function'
        #    throw new Error '客户端emit的#{event}时间没有注册回调函数'
        #  else
        #    emit-callback-fn verify-result
        #else
        done = save-seesion = !~> # patched to each handler, need running at the end of handlers to save-session
          session-store.set @.id, @session, !(session)~>

        Array.prototype.push.call arguments, done
        new-arg = arguments

        if !@session
          session-store.get @.id, !(session)~>
            @session = session <<< {sid: @.id}
            listener.apply listener, new-arg
        else
          listener.apply listener, new-arg
      require("events").EventEmitter.prototype.on.call @, event, new-listener
