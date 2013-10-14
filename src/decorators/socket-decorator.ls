require! Decorator: './decorator'

get-socket-decorator = (listener)->
  socket-decorator = new Decorator!
  socket-decorator.is-last-decoratee = true
  socket-decorator.handle = !(data, callback)->
    Array.prototype.push.call data.args, callback
    listener.apply listener, data.args
  socket-decorator


module.exports =
  decorate-socket-on: !(decorator)->
    Socket = require 'socket.io/lib/socket.js'
    Socket.prototype.on = !(event, listener)->
      new-listener = !->
        decorator.set-last-decoratee get-socket-decorator listener
        debug " capture #{event} at #{@.id} the session is: ", @session
        <~! decorator.handle {socket: @, event: event, args: arguments}
      require("events").EventEmitter.prototype.on.call @, event, new-listener
