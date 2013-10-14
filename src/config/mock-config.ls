# mock-server 的职责是控制各个channel 的API 使用真实的业务逻辑还是使用mock 数据
#
module.exports <<<
  mock-server:
    # default:
    # interesting-points:
      'request-create-a-new-ip-on-a-new-url': true
      'request-initial': true
      'request-update-location': true
      'answer-location-internality': true
      'create-a-new-reply': true
      'create-a-new-comment': true
    # locations:
    # users:
    # chats:
  
