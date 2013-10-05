require! 'JSV'.JSV
location-json = 
  _id: 'xx'
  type: 'real'
  name: '中大体育馆'
  is-existing: true
  is-internal: false
  duration:
    from: '2014-02-004 12:00:04'
    to: '2014-02-04 12:00:04'
  urls: []
  retrieved-html: '<html>...</html>'
  web-page-snapshot: '/web-page-snapshot/_id'
  alias: ['中大体育馆', '东校区体育馆']
  center-points:
    longitude: '123'
    latitude: '123'
    altitude: '123'
  radius: '123'
  altitude-scope: '123'
  address: 'xxxxx'
  subsituted-location: 'lid-2'

env = JSV.createEnvironment!
instance = env.createInstance location-json
schema = env.createSchema!
schema = 
  description: "a location"
  type: "object"
  properties: 
    name: 
      type: "string"
      maxLength: 100
    type:
      type: 'string'
    is-existing:
      type: 'boolean'
    is-internal:
      type: 'boolean'
    duration:
      type: 'object'
      properties:
        from: 
          type: 'time'
        to:
          type: 'time'
    urls:
      type: 'array'
    retrieved-html:
      type: 'string'
    web-page-snapshot:
      type: 'string'
    alias: 
      type: 'array'
    center-points:
      type: 'object'
      properties:
        longitude:
          type: 'string'
        latitude:
          type: 'string'
        altitude:
          type: 'string'
    radius:
      type: 'string'
    altitude-scope:
      type: 'string'
    subsituted-location:
      type: 'string'


report = env.validate location-json, schema

if report.errors.length === 0
  console.log 'schema is valid'
