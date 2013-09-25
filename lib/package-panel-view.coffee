{$$, View} = require 'atom'

module.exports =
class PackagePanelView extends View
  @content: (title) ->
    @div class: 'tool-panel padded', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', title
        @div class: 'panel-body padded', =>
          @div class: 'text-info', outlet: 'summary'
          @ul class: 'list-group', outlet: 'list'

  addPackages: (packages, timeKey) ->
    @addPackage(pack, timeKey) for pack in packages

  addPackage: (pack, timeKey) ->
    @list.append $$ ->
      @li class: 'list-item', =>
        @span class: 'inline-block', pack.name
        highlightClass = 'highlight-warning'
        highlightClass = 'highlight-error' if pack[timeKey] > 25
        @span class: "inline-block #{highlightClass}", "#{pack[timeKey]}ms"
