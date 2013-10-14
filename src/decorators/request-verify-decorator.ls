require! Decorator: './decorator'
require! './scheme-manager'

event-need-to-be-verified = (event-name)->
  safe-events =
    'request-initial'
    ...
  debug "#{event-name} need to be verified? #{not (event-name in safe-events)}"
  not (event-name in safe-events)

class Request-verify-decorator extends Decorator
  ->
    super!
  # data:
  #   event: 请求事件
  #   socket: 对应的socket对象
  #   args: 客户端emit的参数
  before: !(data, callback)->
    debug '================== RUNNING request verify decorator ================='
    request-data =
      | !data.args[0] or typeof! data.args[0] is 'Function' => {}
      | otherwise => data.args[0]
    debug 'request-data: ',request-data
    if event-need-to-be-verified data.event and (verify-result = scheme-manager.verify-request-data data.event, request-data).result is 'failed'
      emit-callback-fn = data.args[*-1]
      if typeof! emit-callback-fn isnt 'Function'
        throw new Error "客户端emit的#{data.event}事件没有注册回调函数"
      else
        debug 'verify-result: ', verify-result
        emit-callback-fn verify-result
        callback 'failed'
    else
      callback 'success'

  after: !(data, callback)->
    debug '===================== FINISH verify decorator ======================='
    callback!

module.exports = Request-verify-decorator
