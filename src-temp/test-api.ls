debug = require('debug')('at-plus')
# ！！目前这里的代码没有更新和维护。暂时保留，以防将来需要利用浏览器进行调试。


BASE_URL = 'http://localhost:3000'

client1 = io.connect BASE_URL

client1.on 'initial', !(data)->
  console.log 'client1.socket.sessionid': client1.socket.sessionid
  console.log 'data: ', data
  client1.emit 'request-1', null 

client1.on 'request-1-answer', !(data)->
  console.log 'data: ', data

client2 = io.connect BASE_URL + '/locations'

client2.on 'ready', !(data)->
  console.log 'client2.socket.sessionid': client2.socket.sessionid
  console.log 'data: ', data
