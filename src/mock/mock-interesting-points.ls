#
#require! ['./mock-data']
_ = require 'underscore'

mock-create-a-new-ip-on-a-new-url =  (data, callback) -> # 直接返回报文
  debug 'in mock-create-a-new-ip-on-a-new-url'
  callback!


module.exports = 
  mock-create-a-new-ip-on-a-new-url: mock-create-a-new-ip-on-a-new-url


