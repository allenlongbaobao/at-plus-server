create-a-new-reply-schema = 
  type: 'object'
  additional-properties: false 
  properties:
    ipid:
      description: 'the ObjectiId of interesting point'
      type: 'string'
      required: true
    reply:
      description: '需要创建的回复'
      type: 'object'
      additional-properties: false
      required: true
      properties: 
        r-mid:
          description: '回复某条评论的id'
          type: 'string'
        original-content-type: 
          description: '回复类型'
          type: 'string'
        text-content: 
          description: '如果回复类型为文字, 则该项有内容'
          type: 'string'
        voice-content:
          description: '如果回复类型为语音, 则该项有内容'
          type: 'string'
        at-users: 
          description: '@的用户'
          type: 'array'
        reposts-type:
          description: '转发到其他社交平台, 可选'
          type: 'array'
