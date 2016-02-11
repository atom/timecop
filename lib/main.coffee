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

if parseFloat(atom.getVersion()) < 1.7
  atom.deserializers.add
    name: 'TimecopView'
    deserialize: module.exports.createTimecopView.bind(module.exports)
