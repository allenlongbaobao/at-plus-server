require! H: './test-create-a-new-ip-on-a-new-url-helper'

describe '测试在新URL上创建新兴趣点时，Locations Channel与Interesting Points Channel的协同', !->
  describe '创建兴趣点后，客户端接收到正确的数据，服务端正确保存了兴趣点', !->
    testing-data = total-locations-in-db = total-interestiong-points-in-db = null
    before-each !->
      count-locaitons-in-db !(amount)-> total-locations-in-db := amount
      count-interesting-points-in-db !(amount)-> total-interestiong-points-in-db := amount
      testing-data := prepare-testing-data!

    describe 'url为已有locatoin的alias时，消息内容正确，兴趣点正确保存', !->
      can '创建者收到response-create-a-new-ip-on-a-new-url，之前在此页面的用户收到push-location-updated', !(done)->
        (creator, observer, wait) <-! H.open-two-clients is-url-new-location = false, done
        creator.ip.on 'response-create-a-new-ip-on-a-new-url', wait !(data)-> 
          debug "创建者收到创建成功消息"
          data.should.have.property 'lid'
          data.should.have.property 'ipid'
          data.result.should.eql 'success'

          done-waiter = wait!
          <-! should-db-not-include-any-new-location total-locations-in-db
          <-! should-new-location-url-added-as-alias testing-data.request-create-a-new-ip-on-a-new-url
          <-! should-db-include-a-new-interesting-point total-interestiong-points-in-db
          <-! should-db-include-the-requested-new-ip testing-data.request-create-a-new-ip-on-a-new-url
          done-waiter!

        observer.locations.on 'push-location-updated', wait !(data)-> 
          debug "观察者收到location更新消息"
          data.type.should.eql 'new-ip-added'
          data.should.have.property '_id'
          data.added-interesting-point.should.have.property '_id'
          data.added-interesting-point.created-by.should.have.property '_id'
          (utils.chop-off-id data).should.eql (utils.chop-off-id testing-data.push-location-updated)

        creator.locations.on 'push-location-updated', !(data)-> 
          should.fail "创建者收到了'push-location-updated'"
          
        observer.ip.on 'response-create-a-new-ip-on-a-new-url', !(data)-> 
          should.fail "观察者收到了'response-create-a-new-ip-on-a-new-url'"

        creator.ip.emit 'request-create-a-new-ip-on-a-new-url', testing-data.request-create-a-new-ip-on-a-new-url


  before-each !(done)->
    <-! server.start
    socket-helper.clear-all-client-sockets! # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    utils.prepare-clean-test-db done
    debug 'prepare-clean-test-db complete'

  after-each !(done)->
    utils.close-db !->
      socket-helper.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #

prepare-testing-data = ->
  request-create-a-new-ip-on-a-new-url: utils.load-fixture 'request-create-a-new-ip-on-a-new-url'
  push-location-updated: utils.load-fixture 'push-location-updated'

count-locaitons-in-db = !(callback)->
  count-amount-of-docs-in-a-collection 'locations', callback

count-interesting-points-in-db = !(callback)->
  count-amount-of-docs-in-a-collection 'interesting-points', callback

should-db-not-include-any-new-location = !(old-amount, callback)->
  (locations) <-! query-collection 'locations', {}
  locations.length.should.eql old-amount
  callback!

should-new-location-url-added-as-alias = !(new-ip, callback)->
  (locations) <-! query-collection 'locations', {urls: new-ip.within-location.url}
  locations.length.should.eql 1
  callback!


should-db-include-a-new-interesting-point = !(old-amount, callback)->
  (locations) <-! query-collection 'interesting-points', {} 
  locations.length.should.eql old-amount + 1
  callback!

should-db-include-the-requested-new-ip = !(new-ip, callback)->
  debug "new-ip.title: ", new-ip.title
  (ips) <-! query-collection 'interesting-points', {'title': new-ip.title} 
  ips.length.should.eql 1
  callback!



