#require! ['./mock-data']
_ = require 'underscore'

mock-create-a-new-ip-on-a-new-url =  (data, callback) ->
  debug 'in mock-create-a-new-ip-on-a-new-url'
  callback!


module.exports = 
  mock-create-a-new-ip-on-a-new-url: mock-create-a-new-ip-on-a-new-url


