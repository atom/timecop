/** @babel */
/** @jsx etch.dom */

import _ from 'underscore-plus'
import dedent from 'dedent'
import {Disposable} from 'atom'
import etch from 'etch'
import CachePanelView from './cache-panel-view'
import PackagePanelView from './package-panel-view'
import WindowPanelView from './window-panel-view'

export default class TimecopView {
  constructor ({uri}) {
    this.uri = uri
    etch.initialize(this)
    if (atom.packages.getActivePackages().length > 0) {
      this.populateViews()
    } else {
      // Render on next tick so packages have been activated
      setImmediate(() => { this.populateViews() })
    }
  }

  update () {}

  destroy () {
    return etch.destroy(this)
  }

  render () {
    return (
      <div className='timecop pane-item native-key-bindings' tabIndex='-1'>
        <div className='timecop-panel'>
          <div className='panels'>
            <WindowPanelView ref='windowLoadingPanel' />
            <CachePanelView ref='cacheLoadingPanel' />
          </div>
          <div className='panels'>
            <PackagePanelView ref='packageLoadingPanel' title='Package Loading' />
            <PackagePanelView ref='packageActivationPanel' title='Package Activation' />
            <PackagePanelView ref='themeLoadingPanel' title='Theme Loading' />
            <PackagePanelView ref='themeActivationPanel' title='Theme Activation' />
          </div>
        </div>
      </div>
    )
  }

  populateViews () {
    this.refs.windowLoadingPanel.populate()
    this.refs.cacheLoadingPanel.populate()
    this.showLoadedPackages()
    this.showActivePackages()
    this.showLoadedThemes()
    this.showActiveThemes()
  }

  showLoadedPackages () {
    const {time, count, packages} = this.getSlowPackages(
      atom.packages.getLoadedPackages().filter(pack => pack.getType() !== 'theme'),
      'loadTime'
    )
    this.refs.packageLoadingPanel.addPackages(packages, 'loadTime')
    this.refs.packageLoadingPanel.refs.summary.textContent = dedent`
      Loaded ${count} packages in ${time}ms.
      ${_.pluralize(packages.length, 'package')} took longer than 5ms to load.
    `
  }

  showActivePackages () {
    const {time, count, packages} = this.getSlowPackages(
      atom.packages.getActivePackages().filter(pack => pack.getType() !== 'theme'),
      'activateTime'
    )
    this.refs.packageActivationPanel.addPackages(packages, 'activateTime')
    this.refs.packageActivationPanel.refs.summary.textContent = dedent`
      Activated ${count} packages in ${time}ms.
      ${_.pluralize(packages.length, 'package')} took longer than 5ms to activate.\
    `
  }

  showLoadedThemes () {
    const {time, count, packages} = this.getSlowPackages(atom.themes.getLoadedThemes(), 'loadTime')
    this.refs.themeLoadingPanel.addPackages(packages, 'loadTime')
    this.refs.themeLoadingPanel.refs.summary.textContent = dedent`
      Loaded ${count} themes in ${time}ms.
      ${_.pluralize(packages.length, 'theme')} took longer than 5ms to load.\
    `
  }

  showActiveThemes () {
    const {time, count, packages} = this.getSlowPackages(atom.themes.getActiveThemes(), 'activateTime')
    this.refs.themeActivationPanel.addPackages(packages, 'activateTime')
    this.refs.themeActivationPanel.refs.summary.textContent = dedent`
      Activated ${count} themes in ${time}ms.
      ${_.pluralize(packages.length, 'theme')} took longer than 5ms to activate.\
    `
  }

  getSlowPackages (packages, timeKey) {
    let time = 0
    let count = 0
    packages = packages.filter(function (pack) {
      time += pack[timeKey]
      count++
      return pack[timeKey] > 5
    })
    packages.sort((pack1, pack2) => pack2[timeKey] - pack1[timeKey])
    return {time, count, packages}
  }

  serialize () {
    return {
      deserializer: this.constructor.name,
      uri: this.getURI()
    }
  }

  getURI () {
    return this.uri
  }

  getTitle () {
    return 'Timecop'
  }

  getIconName () {
    return 'dashboard'
  }

  onDidChangeTitle () {
    return new Disposable(function () {})
  }

  onDidChangeModified () {
    return new Disposable(function () {})
  }
}
