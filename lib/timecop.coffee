TimecopView = null

viewUri = 'atom://timecop'
createView = (state) ->
  TimecopView ?= require './timecop-view'
  new TimecopView(state)

atom.deserializers.add
  name: 'TimecopView'
  deserialize: (state) -> createView(state)

module.exports =
  activate: ->
    atom.project.registerOpener (filePath) ->
      createView(uri: viewUri) if filePath is viewUri

    atom.rootView.command 'timecop:view', -> atom.rootView.open(viewUri)
