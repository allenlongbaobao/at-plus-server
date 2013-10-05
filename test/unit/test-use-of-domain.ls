require! ['domain']

d = domain.create!

d.on 'error', !(err)->
  console.log err

<-! d.run
have-a-test = !(name, callback) ->
  if name
    callback name
  
have-a-test 'allen',  (data) ->
  d.emit 'error', new Error 'i am an error'
  if data
    console.log data

