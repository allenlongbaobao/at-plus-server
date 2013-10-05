# mock-server 的职责是控制各个channel 的API 使用真实的业务逻辑还是使用mock数据
module.exports <<<
  mock-server:
    default:
      a: false
    ips:
      create-a-new-ip-on-a-new-url: true
    locations:
      a: false
    users:
      a: false
    chats:
      a: false
