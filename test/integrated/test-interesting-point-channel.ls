require! ['./request-create-a-new-reply', './response-create-a-new-reply', './utils']
require! _: 'underscore'
require! H: './test-create-a-new-ip-on-a-new-url-helper'

describe '测试interesting-point channel中的API, 前后端的交互是否正确', !->
  can '创建一条回复消息,如果前端提交到后台的报文正确, 后台返回的相应报文应该是成功后的数据', !(done)->
    create-a-new-reply done 

  can '创建一条评论消息, 如果前段提交到后台的报文正确, 后台返回的相应报文应该是成功后的数据', !(done)->
    create-a-new-comment done

  before-each !(done)->
    <-! server.start
    socket-helper.clear-all-client-sockets!
    utils.prepare-clean-test-db done
    debug 'prepare-clean-test-db complete'

  after-each !(done)->
    utils.close-db !->
      #socket.helper.Sockets-destroyer.get!.destroy-all! 
      server.shutdown!
      done!

# -------------------------- 以下是辅助代码 -------------------
create-reply-request-data = utils.load-fixture 'request-create-a-new-reply' 
create-comment-request-data = utils.load-fixture 'request-create-a-new-comment'

create-a-new-reply = !(done)->
  (creator, observer, wait) <-! H.open-two-clients  is-url-new-location=false, done 
  debug 'create-comment-request-data:', create-reply-request-data
  creator.ip.emit 'create-a-new-reply', create-reply-request-data, wait !(data)->
    debug '用户A新建了一个回复'
    data.result.should.eql 'success'

create-a-new-comment = !(done)->
  (creator, observer, wait) <-! H.open-two-clients is-url-new-location = false, done
  debug 'create-comment-request-data:', create-comment-request-data
  creator.ip.emit 'create-a-new-comment', create-comment-request-data, wait !(data)->
    debug '用户A新建了一条评论'
    data.result.should.eql 'success'
    
  



