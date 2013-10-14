#成功
response-create-a-new-comment = 
  result: 'success'
  errors: []
  comment:
    _id: 'mid-1'
    type: 'ip-msg'
    ipid: 'ipid-1'
    original-content-type: 'text'
    text-content: '@+ is wonderful'
    voice-content: void
    at-users: ['uid-1', 'uid-2']
    create-time: '2013-02-05 12:00:00'
    send-by: 'uid-4'
    reposts:
      * type: 'weibo'
        repost-id: 'xxxx'
        url: 'http://weibo.com/xxx'
      * type: 'twitter'
        repost-id: 'xxxx'
        url: 'http://twitter.com/xxx'
      ...
    is-copied-from-third-part: false
    permlink: 'http://at-plus.com/xxx'
 
#失败
'''
response-create-a-new-comment =
  result: 'failed'
  errors:
    * attribute: 'required'
      details: false
      message: 'Property is required'
      schema-uri: 'urn:uuid:46a7243b-02d3-496d-a98c-23f071694b2e#/properties/uid'
      uri: 'urn:uuid:358773a2-7d00-4319-96f4-b29e5ca2dc66#/uid'
    ...
'''
