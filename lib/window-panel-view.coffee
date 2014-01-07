{View} = require 'atom'

module.exports =
class WindowPanelView extends View
  @content: ->
    @h5 class: 'overview text-highlight'

  populate:  ->
    @text("This window took #{atom.getWindowLoadTime()}ms to load.")
