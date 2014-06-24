{View} = require 'atom'

module.exports =
class WindowPanelView extends View
  @content: ->
    @div class: 'padded', =>
      @div =>
        @span class: 'inline-block', 'Window load time'
        @span class: 'inline-block', outlet: 'windowLoadTime'

      @div outlet: 'deserializeTimings', =>
        @div class: 'deserialize-timing', =>
          @span class: 'inline-block', 'Workspace load time'
          @span class: 'inline-block', outlet: 'workspaceLoadTime'

        @div =>
          @span class: 'inline-block', 'Project load time'
          @span class: 'inline-block', outlet: 'projectLoadTime'

  updateWindowLoadTime: ->
    time = atom.getWindowLoadTime()
    @windowLoadTime.addClass(@getHighlightClass(time))
    @windowLoadTime.text("#{time}ms")

    if atom.deserializeTimings?
      @workspaceLoadTime.addClass(@getHighlightClass(atom.deserializeTimings.workspace))
      @workspaceLoadTime.text("#{atom.deserializeTimings.workspace}ms")
      @projectLoadTime.addClass(@getHighlightClass(atom.deserializeTimings.project))
      @projectLoadTime.text("#{atom.deserializeTimings.project}ms")
    else
      @deserializeTimings.hide()

  getHighlightClass: (time) ->
    if time > 1000
      'highlight-error'
    else if time > 800
      'highlight-warning'
    else
      'highlight-info'

  populate:  ->
    @updateWindowLoadTime()
