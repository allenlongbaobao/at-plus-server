class Decorator
  ->
    @decoratee = null
    @is-last-decoratee = false

  use: (@decoratee)->
    @decoratee

  handle: !(data, callback)->
    (result)<~! @decoratee.before data 
    if result isnt 'failed'
      <~! @decoratee.handle data
      <~! @decoratee.after data
      callback!
    else
      <~! @decoratee.after data
      callback!

  # 子类需要实现的逻辑
  before: !(data, callback)-> callback!
  after: !(data, callback)-> callback!

  set-last-decoratee: (last)->
    (@find-last-decoratee @).decoratee = last

  find-last-decoratee: (decorator)->
    if decorator.decoratee and not decorator.decoratee.is-last-decoratee
      @find-last-decoratee decorator.decoratee
    else
      decorator

module.exports = Decorator
