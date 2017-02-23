TimecopView = null
ViewURI = 'atom://timecop'

module.exports =
  activate: ->
    atom.workspace.addOpener (filePath) =>
      @createTimecopView(uri: ViewURI) if filePath is ViewURI

    atom.commands.add 'atom-workspace', 'timecop:view', ->
      atom.workspace.open(ViewURI)

  createTimecopView: (state) ->
    TimecopView ?= require './timecop-view'
    new TimecopView(state)
