TimecopView = null

ViewUri = 'atom://timecop'

createView = (state) ->
  TimecopView ?= require './timecop-view'
  new TimecopView(state)

atom.deserializers.add
  name: 'TimecopView'
  deserialize: (state) -> createView(state)

module.exports =
  activate: ->
    atom.workspace.registerOpener (filePath) ->
      createView(uri: ViewUri) if filePath is ViewUri

    atom.commands.add 'atom-workspace', 'timecop:view', ->
      atom.workspace.open(ViewUri)
