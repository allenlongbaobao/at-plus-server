create-a-new-comment-schema = 
  type: 'object'
  additional-properties: false
  properties:
    ipid: 
      description: 'the ObjectiId of interesting point'
      type: 'string'
      required: true
    comment:
      description: '需要创建的评论'
      type: 'object'
      required: true
      additional-properties: false
      properties:
        ipid: 
          description: 'the ObjectiId of interesting point'
          type: 'string'
          required: true
        original-content-type: 
          description: '评论类型'
          type: 'string'
          required: true
        text-content: 
          description: '如果评论类型为文字, 则该项有内容'
          type: 'string'
          required: false
           
        voice-content:
          description: '如果评论类型为语音, 则该项有内容'
          type: 'string'
          required: false
        at-users: 
          description: '@的用户'
          type: 'array'
          required: true
        reposts-type:
          description: '转发到其他社交平台, 可选'
          type: 'array'
          required: false
