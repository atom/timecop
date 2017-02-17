path = require 'path'
CompileCache = require path.join(atom.getLoadSettings().resourcePath, 'src', 'compile-cache')
CSON = require path.join(atom.getLoadSettings().resourcePath, 'node_modules', 'season')

describe "Timecop", ->
  workspaceElement = null

  beforeEach ->
    spyOn(CompileCache, 'getCacheStats').andReturn {
      '.js': {hits: 3, misses: 4},
      '.ts': {hits: 5, misses: 6},
      '.coffee': {hits: 7, misses: 8},
    }

    spyOn(CSON, 'getCacheMisses').andReturn 10

    atom.themes.lessCache.cache.stats.misses = 12

    workspaceElement = atom.views.getView(atom.workspace)
    waitsForPromise ->
      atom.packages.activatePackage('timecop')

  describe "the timecop:view command", ->
    timecopView = null

    beforeEach ->
      packages = [
        new FakePackage(
          name: 'slow-activating-package-1'
          activateTime: 500
          loadTime: 5
        )
        new FakePackage(
          name: 'slow-activating-package-2'
          activateTime: 500
          loadTime: 5
        )
        new FakePackage(
          name: 'slow-loading-package'
          activateTime: 5
          loadTime: 500
        )
        new FakePackage(
          name: 'fast-package'
          activateTime: 2
          loadTime: 3
        )
      ]

      spyOn(atom.packages, 'getLoadedPackages').andReturn(packages)
      spyOn(atom.packages, 'getActivePackages').andReturn(packages)

      atom.commands.dispatch(workspaceElement, 'timecop:view')

      waitsFor ->
        timecopView = atom.workspace.getActivePaneItem()

    afterEach ->
      jasmine.unspy(atom.packages, 'getLoadedPackages')

    it "shows the packages that loaded slowly", ->
      loadingPanel = timecopView.refs.packageLoadingPanel
      expect(loadingPanel.element.textContent).toMatch(/1 package took longer than 5ms to load/)
      expect(loadingPanel.element.textContent).toMatch(/slow-loading-package/)

      expect(loadingPanel.element.textContent).not.toMatch(/slow-activating-package/)
      expect(loadingPanel.element.textContent).not.toMatch(/fast-package/)

    it "shows the packages that activated slowly", ->
      activationPanel = timecopView.refs.packageActivationPanel
      expect(activationPanel.element.textContent).toMatch(/2 packages took longer than 5ms to activate/)
      expect(activationPanel.element.textContent).toMatch(/slow-activating-package-1/)
      expect(activationPanel.element.textContent).toMatch(/slow-activating-package-2/)

      expect(activationPanel.element.textContent).not.toMatch(/slow-loading-package/)
      expect(activationPanel.element.textContent).not.toMatch(/fast-package/)

    it "shows how many files were transpiled from each language", ->
      cachePanel = timecopView.refs.cacheLoadingPanel

      expect(cachePanel.element.textContent).toMatch /CoffeeScript files compiled\s*8/
      expect(cachePanel.element.textContent).toMatch /Babel files compiled\s*4/
      expect(cachePanel.element.textContent).toMatch /Typescript files compiled\s*6/
      expect(cachePanel.element.textContent).toMatch /CSON files compiled\s*10/
      expect(cachePanel.element.textContent).toMatch /Less files compiled\s*12/

class FakePackage
  constructor: ({@name, @activateTime, @loadTime}) ->
  getType: -> 'package'
  isTheme: -> false
