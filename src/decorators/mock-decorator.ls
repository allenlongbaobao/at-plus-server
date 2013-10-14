require! Decorator: './decorator', _: 'underscore'
require! ['./mock-config'.mock-server, 'fs']

is-implemented-api = (event-name)->
  debug "#{event-name} has been implemented? #{mock-server[event-name]}"
  mock-server[event-name]

get-mock-response = (event-name)->
  response-file-path = __dirname + '/../test-bin/response-' + event-name + '.js'
  eval fs.read-file-sync response-file-path, {encoding: 'utf-8'}

class  mock-decorator extends Decorator
  ->
    super!

  before: !(data, callback)->
    debug '==================== RUNNING mock decorator ==================='
    emit-callback-fn = data.args[*-1]
    if is-implemented-api data.event
      callback!
    else
      if typeof! emit-callback-fn isnt 'Function'
        throw new Error "客户端emit的#{data.event}事件没有注册回调函数"
      else
        emit-callback-fn get-mock-response data.event
  after: !(data, callback)->
    debug '==================== FUNISH mock decorator ===================='
    callback!


module.exports = mock-decorator


