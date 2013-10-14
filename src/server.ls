require! [express, http, path, 'socket.io', 'connect', 'domain', './database', './socket-decorator', './session-decorator', './request-verify-decorator', './mock-decorator', './decorator', './patchs'
  './default-channel', './testing-helper-channel', './locations-channel', './interesting-points-channel', './users-channel', './config', './session-store']

server-domain = domain.create!
server-domain.on 'error', !(err)->
  console.log '=============== Error Handle ================'
  console.log 'Error message: ', err.message
  console.log 'Error stack:', err.stack
  console.log '============================================='

port = process.env.PORT or config.server.port 
 
server = null
configure-at-plus-server = !->
  server := express!
  session-store.config config.session-store
  server.configure ->
    server.set 'port', port
    server.use server.router
    server.use express.static __dirname 

  # server.configure 'development', -> 
  #   server.use express.errorHandler!

  server.get '/', !(req, res)-> # test page 
    res.sendfile __dirname + '/index.html'

initial-at-plus-server = !->
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server
  io.set 'log level', 1

  default-channel.init io
  testing-helper-channel.init io # ！！注意：仅用于测试，正式发布时需要去掉。
  locations-channel.init io
  interesting-points-channel.init io
  users-channel.init io

decorator-bootstrap = new decorator!
decorator-bootstrap
  .use new session-decorator!
  .use new request-verify-decorator!
  .use new mock-decorator!
socket-decorator.decorate-socket-on decorator-bootstrap
# patchs.patch-socket-with-accross-namespaces-session!

module.exports =
  start: !(done)->
    <-! server-domain.run
    if not process.env.SERVER_ALREADY_RUNNING
      console.info "\n****************** start server **********************"
      configure-at-plus-server!
      initial-at-plus-server!
      server.http-server.listen port, ->
        console.info "at-plus is listening on port #{port}" 
        done! if done 
    else
      done! if done
  shutdown: !->
    if not process.env.SERVER_ALREADY_RUNNING
      console.info "****************** close server **********************\n\n" 
      server.http-server.close!
