{_, $$, ScrollView} = require 'atom'

module.exports =
class TimecopView extends ScrollView
  @content: ->
    @div class: 'timecop pane-item', tabindex: -1, =>
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
              @div class: 'text-info', outlet: 'packageActivateSummary'
              @ul class: 'list-group', outlet: 'packageActivateArea'

      @div class: 'tool-panel padded', =>
        @div class: 'panel', =>
          @div class: 'inset-panel', =>
            @div class: 'panel-heading', 'Theme Loading'
            @div class: 'panel-body padded', =>
              @div class: 'text-info', outlet: 'themeLoadingSummary'
              @ul class: 'list-group', outlet: 'themeLoadingArea'

      @div class: 'tool-panel padded', =>
        @div class: 'panel', =>
          @div class: 'inset-panel', =>
            @div class: 'panel-heading', 'Theme Activation'
            @div class: 'panel-body padded', =>
              @div class: 'text-info', outlet: 'themeActivateSummary'
              @ul class: 'list-group', outlet: 'themeActivateArea'

  initialize: ({@uri}) ->
    if atom.getActivePackages().length > 0
      @populateViews()
    else
      # Render on next tick so packages have been activated
      _.nextTick => @populateViews()

  populateViews: ->
    @showLoadedPackages()
    @showActivePackages()
    @showLoadedThemes()
    @showActiveThemes()

  getSlowPackages: (packages, timeKey) ->
    time = 0
    count = 0
    packages = packages.filter (pack) ->
      time += pack[timeKey]
      count++
      pack[timeKey] > 5
    packages.sort (pack1, pack2) -> pack2[timeKey] - pack1[timeKey]
    {time, count, packages}

  createPackageView: (pack, timeKey) ->
    $$ ->
      @li class: 'list-item', =>
        @span class: 'inline-block', pack.name
        highlightClass = 'highlight-warning'
        highlightClass = 'highlight-error' if pack[timeKey] > 25
        @span class: "inline-block #{highlightClass}", "#{pack[timeKey]}ms"

  showLoadedPackages: ->
    {time, count, packages} = @getSlowPackages(atom.getLoadedPackages(), 'loadTime')
    for pack in packages
      @loadingArea.append(@createPackageView(pack, 'loadTime'))
    @loadingSummary.text """
      Loaded #{count} packages in #{time}ms.
      #{packages.length} packages took longer than 5ms to load.
    """

  showActivePackages: ->
    {time, count, packages} = @getSlowPackages(atom.getActivePackages(), 'activateTime')
    for pack in packages
      @packageActivateArea.append(@createPackageView(pack, 'activateTime'))
    @packageActivateSummary.text """
      Activated #{count} packages in #{time}ms.
      #{packages.length} packages took longer than 5ms to activate.
    """

  showLoadedThemes: ->
    {time, count, packages} = @getSlowPackages(atom.themes.getLoadedThemes(), 'loadTime')
    for pack in packages
      @themeLoadingArea.append(@createPackageView(pack, 'loadTime'))
    @themeLoadingSummary.text """
      Loaded #{count} themes in #{time}ms.
      #{packages.length} themes took longer than 5ms to load.
    """

  showActiveThemes: ->
    {time, count, packages} = @getSlowPackages(atom.themes.getActiveThemes(), 'activateTime')
    for pack in packages
      @themeActivateArea.append(@createPackageView(pack, 'activateTime'))
    @themeActivateSummary.text """
      Activated #{count} packages in #{time}ms.
      #{packages.length} packages took longer than 5ms to activate.
    """

  serialize: ->
    deserializer: @constructor.name
    uri: @getUri()

  getUri: -> @uri

  getTitle: -> 'Timecop'
