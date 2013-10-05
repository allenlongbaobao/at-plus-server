require! H: './test-create-a-new-ip-on-a-new-url-helper'
testing-data = total-locations-in-db = total-interestiong-points-in-db = null

describe '测试在一个已存在的兴趣点上发送msg信息, Interesting Points Channel 和 Message Channel的协同', !->
  describe '用户小东在(优酷足球)兴趣点上发言, 消息发送正确, 保存正确', !->
    can '成功后,小东能够收到返回信息,所有用户(包括小东)能够收到该条发言信息', !(done)->
      should-sender-and-observer-recieved-correct-messages-AND-ip-updated done

  describe '客户端发送了一条缺失部分信息的报文, 服务端应该能够识别,并返回错误信息', !(done)->
    can '发送缺失了部分信息的报文,服务器应能够响应错误', !(done)->
      should-response-err-when-msg-has-err done

  before-each !(done)->
    testing-data := prepare-testing-data!
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
  request-send-a-message-on-an-ip: utils.load-fixture 'request-send-a-message-on-an-ip'
  request-send-an-err-message-on-an-ip: utils.load-fixture 'request-send-an-err-message-on-an-ip'
  push-ip-updated: utils.load-fixture 'push-ip-updated'

should-sender-and-observer-recieved-correct-messages-AND-ip-updated = !(done)->
  (sender, observer,wait) <-! H.open-two-clients false, done
  sender.ip.on 'response-send-a-new-message-on-an-ip',  wait !(data)->
    debug '发送者收到发送成功信息'
    data.should.have.property 'mid'
    data.should.have.property 'ipid'
    data.result.should.eql 'success'

  (testing-data-to-send) <-! add-ipid-and-lid-to-testing-data testing-data.request-send-a-message-on-an-ip
  observer.ip.on 'push-ip-updated', !(data)->
    debug '观察者收到兴趣点更新信息'
    data.type.should.equal 'new-msg-added'
    data.added-msg.should.have.property 'mid'
  sender.ip.emit 'request-send-a-new-message-on-an-ip', testing-data-to-send 

should-response-err-when-msg-has-err = !(done)->
  (sender, observer, wait) <-! H.open-two-clients false, done 
  sender.ip.on 'message-have-an-err', wait !(data)->
    debug '发送者收到信息错误提示'
  
  observer.ip.on 'push-ip-updated', !(data)->
    debug '观察者收到兴趣点更新信息'
    should.fail '观察者收到兴趣点更新信息'
    
  (testing-data-to-send) <-! add-ipid-and-lid-to-testing-data testing-data.request-send-an-err-message-on-an-ip
  sender.ip.emit 'request-send-a-new-message-on-an-ip', testing-data-to-send
  

add-ipid-and-lid-to-testing-data = !(testing-data, callback) ->
  testing-data.ipid = 'ipid2'
  callback testing-data

