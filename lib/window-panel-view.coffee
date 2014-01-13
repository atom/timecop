{View} = require 'atom'

module.exports =
class WindowPanelView extends View
  @content: ->
    @div class: 'padded', =>
      @span class: 'inline-block', 'Window load time'
      @span class: 'inline-block', outlet: 'windowLoadTime'

  updateWindowLoadTime: ->
    time = atom.getWindowLoadTime()
    highlightClass = 'highlight-info'
    highlightClass = 'highlight-warning' if time > 800
    highlightClass = 'highlight-error' if time > 1000
    @windowLoadTime.addClass(highlightClass)
    @windowLoadTime.text("#{time}ms")

  populate:  ->
    @updateWindowLoadTime()
