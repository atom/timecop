let TimecopView = null
const ViewURI = 'atom://timecop'

module.exports = {
  activate() {
    atom.workspace.addOpener(filePath => {
      if (filePath === ViewURI) return this.createTimecopView({uri: ViewURI})
    })

    atom.commands.add('atom-workspace', 'timecop:view', () => atom.workspace.open(ViewURI))
  },

  createTimecopView(state) {
    if (TimecopView == null) TimecopView = require('./timecop-view')
    return new TimecopView(state)
  }
}
