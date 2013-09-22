TimecopView = null

viewUri = 'atom://timecop'
createView = (state) ->
  TimecopView ?= require './timecop-view'
  new TimecopView(state)

registerDeserializer
  name: 'TimecopView'
  deserialize: (state) -> createView(state)

module.exports =
  activate: ->
    project.registerOpener (filePath) ->
      createView(uri: viewUri) if filePath is viewUri

    rootView.command 'timecop:view', -> rootView.open(viewUri)
