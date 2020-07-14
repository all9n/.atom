# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

# Custom commands

# Mark sexp backward. Often this is more useful than mark sexp (forward)
# XXX: this still does not work; unable to get the service
# atom.workspace.packageManager.serviceHub.consume "atomic-emacs", "^0.13.0", service ->
#     window.emacs = service
#
# markBackwardSexp = (event) ->
#   emacsEditor = emacs.getEditor(event)
#   emacsCursor = emacsEditor.moveEmacsCursors(emacsCursor) ->
#     range = emacsCursor.getMarker().getBufferRange()
#     newHead = emacsCursor._sexpBackwardFrom(range.start)
#     mark = emacsCursor.mark().set(newHead)
#     mark.activate() unless mark.isActive()
#
# atom.commands.add 'atom-text-editor', 'allen:mark-backward-sexp', (event) ->
#   markBackwardSexp(event)


# One command to toggle between: 1. make and run tests; 2 close the test result
# buffer w/o asking to save.
# Only tested on MacOS
atom.commands.add 'atom-workspace', 'allen:make-run-close-test', do ->
  ran_test = false
  result_pane = atom.workspace.getActivePane()
  result_item = null;
  ->
    if ran_test
      # destroy the test result tab if present
      ran_test = false
      if result_pane? && result_item?
        result_pane.destroyItem result_item, true
    else
      # make and run
      view = atom.views.getView(atom.workspace.getActiveTextEditor())
      atom.commands.dispatch(view, 'process-palette:make-and-run')
      result_pane.onDidAddItem (event) ->
        result_item = event.item
        ran_test = true


# Close tab without prompting to save changes.
# Intend to use this to view test results in a untitled buffer.
# atom.commands.add 'atom-workspace', 'allen:close-tab-no-save-prompt', ->
#   active_pane = atom.workspace.getActivePane()
#   active_item = active_pane.getActiveItem()
#   active_pane.destroyItem(active_item, true)

# Split pane and move active item.
# Default commands either split w/o moving item or copies active item, which IMO
# is not useful in most cases.
atom.commands.add 'atom-workspace', 'allen:split-and-move-right', ->
  active_pane = atom.workspace.getActivePane()
  active_item = active_pane.getActiveItem()
  active_pane.splitRight {items:[], copyActiveItem:true}
  active_pane.destroyItem active_item, true

atom.commands.add 'atom-workspace', 'allen:split-and-move-down', ->
  active_pane = atom.workspace.getActivePane()
  active_item = active_pane.getActiveItem()
  active_pane.splitDown {items:[], copyActiveItem:true}
  active_pane.destroyItem active_item, true

atom.commands.add 'atom-workspace', 'allen:split-and-move-left', ->
  active_pane = atom.workspace.getActivePane()
  active_item = active_pane.getActiveItem()
  active_pane.splitLeft {items:[], copyActiveItem:true}
  active_pane.destroyItem active_item, true

atom.commands.add 'atom-workspace', 'allen:split-and-move-up', ->
  active_pane = atom.workspace.getActivePane()
  active_item = active_pane.getActiveItem()
  active_pane.splitUp {items:[], copyActiveItem:true}
  active_pane.destroyItem active_item, true
