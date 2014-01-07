{$$, View} = require 'atom'

module.exports =
class PackagePanelView extends View
  @content: ->
    @div class: 'tool-panel padded', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', 'Window Loading'
        @div class: 'panel-body padded', =>
          @div class: 'text-info', outlet: 'summary'
          @ul class: 'list-group', outlet: 'list'

  populate: ->
    @list.empty()

    @list.append $$ ->
      @li class: 'list-item', =>
        @span class: 'inline-block', 'Total Time'
        highlightClass = 'highlight-success'
        highlightClass = 'highlight-warning' if atom.getWindowLoadTime() > 800
        highlightClass = 'highlight-error' if atom.getWindowLoadTime() > 1000
        @span class: "inline-block #{highlightClass}", "#{atom.getWindowLoadTime()}ms"
