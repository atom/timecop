{View} = require 'atom'

module.exports =
class WindowPanelView extends View
  @content: ->
    @div class: 'padded', =>
      @div class: 'timing', outlet: 'windowTiming', =>
        @span class: 'inline-block', 'Window load time'
        @span class: 'inline-block', outlet: 'windowLoadTime'

      @div class: 'timing', outlet: 'shellTiming', =>
        @span class: 'inline-block', 'Shell load time'
        @span class: 'inline-block', outlet: 'shellLoadTime'

      @div outlet: 'deserializeTimings', =>
        @div class: 'timing', outlet: 'workspaceTiming', =>
          @span class: 'inline-block', 'Workspace load time'
          @span class: 'inline-block', outlet: 'workspaceLoadTime'

        @div class: 'timing', outlet: 'projectTiming', =>
          @span class: 'inline-block', 'Project load time'
          @span class: 'inline-block', outlet: 'projectLoadTime'

        @div class: 'timing', outlet: 'atomTiming', =>
          @span class: 'inline-block', 'Window state load time'
          @span class: 'inline-block', outlet: 'atomLoadTime'

  initialize: ->
    @windowTiming.children().setTooltip('The time taken to load this window')
    @shellTiming.children().setTooltip('The time taken to launch the app')
    @workspaceTiming.children().setTooltip('The time taken to rebuild the prevoiusly opened editors')
    @projectTiming.children().setTooltip('The time taken to rebuild the previously opened buffers')
    @atomTiming.children().setTooltip('The time taken to read and parse the stored window state')

  updateWindowLoadTime: ->
    time = atom.getWindowLoadTime()
    @windowLoadTime.addClass(@getHighlightClass(time))
    @windowLoadTime.text("#{time}ms")

    {shellLoadTime} = atom.getLoadSettings()
    if shellLoadTime?
      @shellLoadTime.addClass(@getHighlightClass(shellLoadTime))
      @shellLoadTime.text("#{shellLoadTime}ms")
    else
      @shellTiming.hide()

    if atom.deserializeTimings?
      @workspaceLoadTime.addClass(@getHighlightClass(atom.deserializeTimings.workspace))
      @workspaceLoadTime.text("#{atom.deserializeTimings.workspace}ms")
      @projectLoadTime.addClass(@getHighlightClass(atom.deserializeTimings.project))
      @projectLoadTime.text("#{atom.deserializeTimings.project}ms")
      @atomLoadTime.addClass(@getHighlightClass(atom.deserializeTimings.atom))
      @atomLoadTime.text("#{atom.deserializeTimings.atom}ms")
    else
      @deserializeTimings.hide()

  getHighlightClass: (time) ->
    if time > 1000
      'highlight-error'
    else if time > 800
      'highlight-warning'
    else
      'highlight-info'

  populate: ->
    @updateWindowLoadTime()
