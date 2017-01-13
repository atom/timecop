{$$, View} = require 'atom-space-pen-views'

module.exports =
class PackagePanelView extends View
  @content: (title) ->
    @div class: 'tool-panel padded package-panel', =>
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
        @a class: 'inline-block package', 'data-package': pack.name, pack.name
        @span class: "timecop-line"
        highlightClass = 'highlight-warning'
        highlightClass = 'highlight-error' if pack[timeKey] > 25
        @span class: "inline-block #{highlightClass}", "#{pack[timeKey]}ms"

  initialize: ->
    @on 'click', 'a.package', ->
      packageName = this.dataset['package']
      atom.workspace.open("atom://config/packages/#{packageName}")
