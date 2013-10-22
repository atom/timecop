{ScrollView} = require 'atom'
PackagePanelView = require './package-panel-view'

module.exports =
class TimecopView extends ScrollView
  @content: ->
    @div class: 'timecop pane-item', tabindex: -1, =>
      @subview 'packageLoadingPanel', new PackagePanelView('Package Loading')
      @subview 'packageActivationPanel', new PackagePanelView('Package Activation')
      @subview 'themeLoadingPanel', new PackagePanelView('Theme Loading')
      @subview 'themeActivationPanel', new PackagePanelView('Theme Activation')

  initialize: ({@uri}) ->
    if atom.getActivePackages().length > 0
      @populateViews()
    else
      # Render on next tick so packages have been activated
      setImmediate => @populateViews()

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

  showLoadedPackages: ->
    {time, count, packages} = @getSlowPackages(atom.getLoadedPackages(), 'loadTime')
    @packageLoadingPanel.addPackages(packages, 'loadTime')
    @packageLoadingPanel.summary.text """
      Loaded #{count} packages in #{time}ms.
      #{packages.length} packages took longer than 5ms to load.
    """

  showActivePackages: ->
    {time, count, packages} = @getSlowPackages(atom.getActivePackages(), 'activateTime')
    @packageActivationPanel.addPackages(packages, 'activateTime')
    @packageActivationPanel.summary.text """
      Activated #{count} packages in #{time}ms.
      #{packages.length} packages took longer than 5ms to activate.
    """

  showLoadedThemes: ->
    {time, count, packages} = @getSlowPackages(atom.themes.getLoadedThemes(), 'loadTime')
    @themeLoadingPanel.addPackages(packages, 'loadTime')
    @themeLoadingPanel.summary.text """
      Loaded #{count} themes in #{time}ms.
      #{packages.length} themes took longer than 5ms to load.
    """

  showActiveThemes: ->
    {time, count, packages} = @getSlowPackages(atom.themes.getActiveThemes(), 'activateTime')
    @themeActivationPanel.addPackages(packages, 'activateTime')
    @themeActivationPanel.summary.text """
      Activated #{count} packages in #{time}ms.
      #{packages.length} packages took longer than 5ms to activate.
    """

  serialize: ->
    deserializer: @constructor.name
    uri: @getUri()

  getUri: -> @uri

  getTitle: -> 'Timecop'
