describe "Timecop", ->
  workspaceElement = null

  beforeEach ->
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
      loadingPanel = timecopView.find(".package-panel:contains(Package Loading)")
      expect(loadingPanel.text()).toMatch(/1 package took longer than 5ms to load/)
      expect(loadingPanel.text()).toMatch(/slow-loading-package/)

      expect(loadingPanel.text()).not.toMatch(/slow-activating-package/)
      expect(loadingPanel.text()).not.toMatch(/fast-package/)

    it "shows the packages that activated slowly", ->
      loadingPanel = timecopView.find(".package-panel:contains(Package Activation)")
      expect(loadingPanel.text()).toMatch(/2 packages took longer than 5ms to activate/)
      expect(loadingPanel.text()).toMatch(/slow-activating-package-1/)
      expect(loadingPanel.text()).toMatch(/slow-activating-package-2/)

      expect(loadingPanel.text()).not.toMatch(/slow-loading-package/)
      expect(loadingPanel.text()).not.toMatch(/fast-package/)

class FakePackage
  constructor: ({@name, @activateTime, @loadTime}) ->
  getType: -> 'package'
  isTheme: -> false
