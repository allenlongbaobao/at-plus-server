require! Decorator: './decorator'
require! './session-store'

class Session-decorator extends Decorator
  ->
    super!
  # data:
  #   event: 请求事件
  #   socket: 对应的socket对象
  #   args: 客户端emit的参数
  before: !(data, callback)->
    debug '================== RUNNING session decorator ==================='
    if !data.socket.session
      session-store.get data.socket.id, !(session)->
        data.socket.session = session <<< {sid: data.socket.id}
        callback!
    else
      callback!
  after: !(data, callback)->
    <-! session-store.set data.socket.id, data.socket.session
    debug '================= FINISH session decorator ====================='
    callback!

module.exports = Session-decorator
