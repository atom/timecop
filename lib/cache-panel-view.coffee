path = require 'path'
{View} = require 'atom-space-pen-views'

module.exports =
class CachePanelView extends View
  @content: ->
    @div class: 'tool-panel padded package-panel', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', 'Compile Cache'
        @div class: 'panel-body padded', =>
          @div class: 'timing', =>
            @span class: 'inline-block', 'CoffeeScript files compiled'
            @span class: 'inline-block highlight-info', outlet: 'coffeeCompileCount', 0

          @div class: 'timing', =>
            @span class: 'inline-block', 'Babel files compiled'
            @span class: 'inline-block highlight-info', outlet: 'babelCompileCount', 0

          @div class: 'timing', =>
            @span class: 'inline-block', 'Typescript files compiled'
            @span class: 'inline-block highlight-info', outlet: 'typescriptCompileCount', 0

          @div class: 'timing', =>
            @span class: 'inline-block', 'CSON files compiled'
            @span class: 'inline-block highlight-info', outlet: 'csonCompileCount', 0

          @div class: 'timing', =>
            @span class: 'inline-block', 'Less files compiled'
            @span class: 'inline-block highlight-info', outlet: 'lessCompileCount', 0

  initialize: ->
    @populate()

  populate: ->
    if compileCacheStats = @getCompileCacheStats()
      @coffeeCompileCount.text(compileCacheStats['.coffee'].misses)
      @babelCompileCount.text(compileCacheStats['.js'].misses)
      @typescriptCompileCount.text(compileCacheStats['.ts'].misses)

    @csonCompileCount.text(@getCsonCompiles())
    @lessCompileCount.text(@getLessCompiles())

  getCompileCacheStats: ->
    try
      require(path.join(atom.getLoadSettings().resourcePath, 'src', 'compile-cache')).getCacheStats()

  getCsonCompiles: ->
    cacheMisses = 0
    try
      CSON = require(path.join(atom.getLoadSettings().resourcePath, 'node_modules', 'season'))
      cacheMisses = CSON.getCacheMisses?() ? 0
    cacheMisses

  getLessCompiles: ->
    atom.themes.lessCache?.cache?.stats?.misses ? 0
