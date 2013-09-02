require! [express, http, path, jade, 'socket.io', 'connect',
  './locations-channel', './interesting-points-channel', './config', './session-store']

port = process.env.PORT or config.server.port 
server = configure-at-plus-server!
do
  <-! initial-at-plus-server
  start-at-plus-server!
 
function configure-at-plus-server
  server = express!
  session-store.config config.session-store
  server.configure ->
    server.set 'port', port
    server.use server.router
    server.use express.static __dirname 

  server.configure 'development', -> 
    server.use express.errorHandler!

  server.get '/', !(req, res)-> # test page 
    res.sendfile __dirname + '/index.html'


function initial-at-plus-server callback
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server

  io.on 'connection', (socket)->
    # ！！以下两方法用于测试，正式发布时应当去除
    <-! try-session-data socket
    try-socket-data socket

  locations-channel.init io, callback

function try-session-data socket, next
  (session) <-! session-store.get-session socket
  session.message = 'Good'
  session.save next

function try-socket-data socket
  socket.number = socket.number or Math.random!
  (session) <-! session-store.get-session socket
  socket.emit 'initial', 
    number: socket.number
    message: session.message

  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer', number: socket.number

function start-at-plus-server
  server.http-server.listen port, ->
    console.log "at-plus is listening on port #{port}" 