{_, $$, View} = require 'atom'

module.exports =
class TimecopView extends View
  @content: ->
    @div class: 'timecop pane-item tool-panel', =>
      @div class: 'tool-panel padded', =>
        @div class: 'inset-panel', =>
          @div class: 'panel-heading', 'Package Loading'
          @div class: 'panel-body padded', =>
            @div class: 'text-info', outlet: 'loadingSummary'
            @ul class: 'list-group', outlet: 'loadingArea'

      @div class: 'tool-panel padded', =>
        @div class: 'panel', =>
          @div class: 'inset-panel', =>
            @div class: 'panel-heading', 'Package Activation'
            @div class: 'panel-body padded', =>
              @div class: 'text-info', outlet: 'activateSummary'
              @ul class: 'list-group', outlet: 'activateArea'

  initialize: ({@uri}) ->
    if atom.getActivePackages().length > 0
      @showLoadedPackages()
      @showActivePackages()
    else
      # Render on next tick so packages have been activated
      _.nextTick =>
        @showLoadedPackages()
        @showActivePackages()

  showLoadedPackages: ->
    totalLoadTime = 0
    packageCount = 0
    loadedPackages = atom.getLoadedPackages().filter ({loadTime}) ->
      totalLoadTime += loadTime
      packageCount++
      loadTime > 5

    loadedPackages.sort (pack1, pack2) -> pack2.loadTime - pack1.loadTime
    for pack in loadedPackages
      @loadingArea.append $$ ->
        @li class: 'list-item', =>
          @span class: 'inline-block', pack.name
          highlightClass = 'highlight-warning'
          highlightClass = 'highlight-error' if pack.loadTime > 25
          @span class: "inline-block #{highlightClass}", "#{pack.loadTime}ms"
    @loadingSummary.text """
      Loaded #{packageCount} packages in #{totalLoadTime}ms.
      #{loadedPackages.length} packages took >= 5ms to load.
    """

  showActivePackages: ->
    totalActivateTime = 0
    packageCount = 0
    activePackages = atom.getActivePackages().filter ({activateTime}) ->
      totalActivateTime += activateTime
      packageCount++
      activateTime > 5

    activePackages.sort (pack1, pack2) -> pack2.activateTime - pack1.activateTime
    for pack in activePackages
      @activateArea.append $$ ->
        @li class: 'list-item', =>
          @span class: 'inline-block', pack.name
          highlightClass = 'highlight-warning'
          highlightClass = 'highlight-error' if pack.activateTime > 25
          @span class: "inline-block #{highlightClass}", "#{pack.activateTime}ms"
    @activateSummary.text """
      Activated #{packageCount} packages in #{totalActivateTime}ms.
      #{activePackages.length} packages took >= 5ms to activate.
    """

  serialize: ->
    deserializer: @constructor.name
    uri: @getUri()

  getUri: -> @uri

  getTitle: -> 'Timecop'
