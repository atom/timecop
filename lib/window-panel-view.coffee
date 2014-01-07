{View} = require 'atom'

module.exports =
class PackagePanelView extends View
  @content: ->
    @div class: 'tool-panel padded', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', 'Overview'
        @div class: 'panel-body padded', =>
          @ul class: 'list-group', =>
            @li class: 'list-item', =>
              @span class: 'inline-block', 'Total Load Time'
              @span class: 'inline-block', outlet: 'windowLoading',
            @li class: 'list-item', =>
              @span class: 'inline-block', 'Package Loading'
              @span class: 'inline-block', outlet: 'packageLoading'
            @li class: 'list-item', =>
              @span class: 'inline-block', 'Package Activation'
              @span class: 'inline-block', outlet: 'packageActivation'
            @li class: 'list-item', =>
              @span class: 'inline-block', 'Theme Loading'
              @span class: 'inline-block', outlet: 'themeLoading'
            @li class: 'list-item', =>
              @span class: 'inline-block', 'Theme Activation'
              @span class: 'inline-block', outlet: 'themeActivation'

  updateWindowTime: ->
    highlightClass = 'highlight-success'
    highlightClass = 'highlight-warning' if atom.getWindowLoadTime() > 800
    highlightClass = 'highlight-error' if atom.getWindowLoadTime() > 1000
    @windowLoading.addClass(highlightClass)
    @windowLoading.text("#{atom.getWindowLoadTime()}ms")

  updatePackageLoadingTime: ->
    time = 0
    for pack in atom.packages.getLoadedPackages() when pack.getType() isnt 'theme'
      time += pack.loadTime
    highlightClass = 'highlight-success'
    highlightClass = 'highlight-warning' if time > 250
    highlightClass = 'highlight-error' if time > 500
    @packageLoading.addClass(highlightClass)
    @packageLoading.text("#{time}ms")

  updatePackageActivationTime: ->
    time = 0
    for pack in atom.packages.getActivePackages() when pack.getType() isnt 'theme'
      time += pack.activateTime
    highlightClass = 'highlight-success'
    highlightClass = 'highlight-warning' if time > 250
    highlightClass = 'highlight-error' if time > 500
    @packageActivation.addClass(highlightClass)
    @packageActivation.text("#{time}ms")

  updateThemeLoadingTime: ->
    time = 0
    for pack in atom.packages.getLoadedPackages() when pack.getType() is 'theme'
      time += pack.loadTime
    highlightClass = 'highlight-success'
    highlightClass = 'highlight-warning' if time > 50
    highlightClass = 'highlight-error' if time > 100
    @themeLoading.addClass(highlightClass)
    @themeLoading.text("#{time}ms")

  updateThemeActivationTime: ->
    time = 0
    for pack in atom.packages.getActivePackages() when pack.getType() is 'theme'
      time += pack.activateTime
    highlightClass = 'highlight-success'
    highlightClass = 'highlight-warning' if time > 50
    highlightClass = 'highlight-error' if time > 100
    @themeActivation.addClass(highlightClass)
    @themeActivation.text("#{time}ms")

  populate:  ->
    @updateWindowTime()
    @updatePackageLoadingTime()
    @updatePackageActivationTime()
    @updateThemeLoadingTime()
    @updateThemeActivationTime()
