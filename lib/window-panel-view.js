/** @babel */
/** @jsx etch.dom */

import {CompositeDisposable} from 'atom'
import etch from 'etch'

export default class WindowPanelView {
  constructor () {
    etch.initialize(this)

    this.disposables = new CompositeDisposable()
    this.disposables.add(atom.tooltips.add(this.refs.windowTiming, {title: 'The time taken to load this window'}))
    this.disposables.add(atom.tooltips.add(this.refs.shellTiming, {title: 'The time taken to launch the app'}))
    this.disposables.add(atom.tooltips.add(this.refs.workspaceTiming, {title: 'The time taken to rebuild the previously opened editors'}))
    this.disposables.add(atom.tooltips.add(this.refs.projectTiming, {title: 'The time taken to rebuild the previously opened buffers'}))
    this.disposables.add(atom.tooltips.add(this.refs.atomTiming, {title: 'The time taken to read and parse the stored window state'}))
  }

  update () {}

  destroy () {
    this.disposables.dispose()
    return etch.destroy(this)
  }

  render () {
    return (
      <div className='tool-panel padded package-panel'>
        <div className='inset-panel'>
          <div className='panel-heading'>Startup Time</div>
          <div className='panel-body padded'>
            <div className='timing' ref='windowTiming'>
              <span className='inline-block'>Window load time</span>
              <span className='inline-block' ref='windowLoadTime'></span>
            </div>

            <div className='timing' ref='shellTiming'>
              <span className='inline-block'>Shell load time</span>
              <span className='inline-block' ref='shellLoadTime'></span>
            </div>

            <div ref='deserializeTimings'>
              <div className='timing' ref='workspaceTiming'>
                <span className='inline-block'>Workspace load time</span>
                <span className='inline-block' ref='workspaceLoadTime'></span>
              </div>

              <div className='timing' ref='projectTiming'>
                <span className='inline-block'>Project load time</span>
                <span className='inline-block' ref='projectLoadTime'></span>
              </div>

              <div className='timing' ref='atomTiming'>
                <span className='inline-block'>Window state load time</span>
                <span className='inline-block' ref='atomLoadTime'></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  populate () {
    const time = atom.getWindowLoadTime()
    this.refs.windowLoadTime.classList.add(this.getHighlightClass(time))
    this.refs.windowLoadTime.textContent = time != null ? `${time}ms` : 'NA'

    const {shellLoadTime} = atom.getLoadSettings()
    if (shellLoadTime != null) {
      this.refs.shellLoadTime.classList.add(this.getHighlightClass(shellLoadTime))
      this.refs.shellLoadTime.textContent = `${shellLoadTime}ms`
    } else {
      this.refs.shellTiming.style.display = 'none'
    }

    if (atom.deserializeTimings != null) {
      this.refs.workspaceLoadTime.classList.add(this.getHighlightClass(atom.deserializeTimings.workspace))
      this.refs.workspaceLoadTime.textContent = atom.deserializeTimings.workspace != null ? `${atom.deserializeTimings.workspace}ms` : 'NA'
      this.refs.projectLoadTime.classList.add(this.getHighlightClass(atom.deserializeTimings.project))
      this.refs.projectLoadTime.textContent = atom.deserializeTimings.project != null ? `${atom.deserializeTimings.project}ms` : 'NA'
      this.refs.atomLoadTime.classList.add(this.getHighlightClass(atom.deserializeTimings.atom))
      this.refs.atomLoadTime.textContent = atom.deserializeTimings.atom != null ? `${atom.deserializeTimings.atom}ms` : 'NA'
    } else {
      this.refs.deserializeTimings.style.display = 'none'
    }
  }

  getHighlightClass (time) {
    if (time > 1000) {
      return 'highlight-error'
    } else if (time > 800) {
      return 'highlight-warning'
    } else {
      return 'highlight-info'
    }
  }
}
