require! './socket-decorator'

class Session-decorator extends Decorator
  before: !(request, response, callback)->
    if !@session
      session-store.get @.id, !(session)~>
        @session = session <<< {sid: @.id}
        callback!
    else
      callback!
  after: !(request, response, callback)->
    session-store.set @.id, @session
    callback!




