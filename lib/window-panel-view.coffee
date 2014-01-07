{View} = require 'atom'

module.exports =
class WindowPanelView extends View
  @content: ->
    @h5 class: 'overview text-highlight'

  populate:  ->
    @text("This window loaded in #{atom.getWindowLoadTime()}ms")
