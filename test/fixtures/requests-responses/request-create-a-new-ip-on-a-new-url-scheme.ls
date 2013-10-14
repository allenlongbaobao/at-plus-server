request-create-a-new-ip-on-a-new-url =
  type: 'object'
  properties:
    type:
      description: 'the type of interesting point'
      type: 'string'
      enum: ['web']
      optional: false
    title:
      description: 'the title of interesting point'
      type: 'string'
      optional: false
    content:
      description: 'the content of interesting point'
      type: 'string'
      optional: false
    create-time: 
      description: 'the time of creating the interesting point'
      type: 'string'
      optional: false
    within-location:
      description: 'location object that the interesting point belongs to'
      type: 'object'
      properties:
        location-type:
          description: 'type of the location'
          type: 'string'
          enum: ['web']
          optional: false
        url:
          description: 'thr url of the web location'
          type: 'string'
          optional: false
        name:
          description: 'location name'
          type: 'string'
          optional: false
        at-position:
          description: 'interesting point position in the location'
          type: 'object'
          properties:
            position-within-web-page:
              type: 'object'
              properties:
                related-text-content:
                  description: 'content in the web page that related to the interesting point'
                  type: 'string'
                  optional: false
                related-image:
                  description: 'images in the web page that related to the interesting point'
                  type: 'string'
                  optional: false
                pin-point-dom:
                  description: 'dom element'
                  type: 'string'
                  optional: false
                offset:
                  type: 'object'
                  properties:
                    x:
                      type: 'string'
                      optional: false
                    y:
                      type: 'string'
                      optional: false
                  optional: false
                size:
                  type: 'object'
                  properties:
                    width:
                      type: 'string'
                      optional: false
                    height:
                      type: 'string'
                      optional: false
                  optional: false
              optional:false
          optional: false
      optional: false
    created-by:
      description: 'creator of the interesting point'
      type: 'string'
      optional: false
    is-private:
      description: 'if the interesting point is private'
      type: 'boolean'
      optional: false
    pictures:
      description: 'pictures of the interesting point'
      type: 'array'
      items:
        type: 'object'
        properties:
          type:
            type: 'string'
            enum: ['snapshoot']
            optional: false
          url:
            type: 'string'
            optional: false
          create-time:
            type: 'string'
            optional: false
        optional: false
      optional: false
    tags:
      type: 'array'
      items:
        type: 'string'
      optional: false
