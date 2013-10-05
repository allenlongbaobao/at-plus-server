class Decorator
  ->
    @decoratee = null
    @is-last-decoratee = false

  use: (@decoratee)->
    @decoratee
  handle: !(request, response, callback)->
    <-! @decoratee.before request, response
    <-! @decoratee.handle request, response
    <-! @decoratee.after request, response
  before: !(request, response, callback)->
  
  after: !(request, response, callback)->

  set-last-decoratee: (last)->
    (@find-last-decoratee @).decoratee = last

  find-last-decoratee: (decorator)->
    if decorator.decoratee and not decorator.decoratee.is-last-decoratee
      find-last-decoratee decorator.decoratee
    else 
      decorator
      
get-socket-decorator = (listener)->
  socket-decorator = new Decorator!
  socket-decorator.is-last-decoratee = true
  socket-decorator.handle = !(evnet, result, callback)->
    listener.apply lisener, event, !-> callback result
  socket-decorator

module.exports = 
  Decorator: Decorator
  decorate-socket-on: !(decorator)->
    Socket = require 'socket.io/lib/socket.js'
    Socket.prototype.on = !(event, listener)->
      decorator.set-last-decoratee get-socket-decorator listener
      new-listener = !->
        <~! decorator.handler event, result = {}
    require ("event").EventEmitter.prototype.on.call @, evnet, new-listener
