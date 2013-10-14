require! _:'underscore'
require! ['fs', 'JSV'.JSV]

FIXTURE_PATH = __dirname + '/../test-bin/' # 这样写，是因为在开发时，src目录中的代码也会使用。

env = JSV.create-environment!
verify-request-data = (scheme-name, request-data)->
  scheme = load-scheme scheme-name
  report = env.validate request-data, scheme
  result: if report.errors.length > 0 then 'failed' else 'success'
  errors: report.errors

load-scheme = (scheme-name)->
  scheme-file-path = FIXTURE_PATH + scheme-name + '-scheme.js'
  if fs.exists-sync scheme-file-path
    eval fs.read-file-sync scheme-file-path, {encoding: 'utf-8'}
  else
    throw new Error "服务端找不到标准文档#{scheme-name}-scheme.js"

module.exports =
  verify-request-data: verify-request-data
