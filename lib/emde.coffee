{CompositeDisposable} = require('atom')
{MessagePanelView, LineMessageView, PlainMessageView} = require 'atom-message-panel'
EmdeView    = require ('./emde-view')
Note        = require ('./note')
Evernote    = require ('./evernote')

module.exports = emde =
    emdeView: null
    bottomPanel: null
    subscriptions: null
    messages: null

    config :

        # General Settings
        execFile:
            title: 'Evernote executable location'
            description: 'The path of where evenote is installed'
            type: 'string'
            default: 'Program Files (x86)/Evernote/Evernote/Evernote.exe'
            order: 1

        enScript:
            title: 'Evernote script executable location'
            description: 'The path of the evernote script (ENScript) executable'
            type: 'string'
            default: 'Program Files (x86)/Evernote/Evernote/ENScript.exe'
            order: 2

    initialize: (state) ->
        # Called before everything, evern workspace deserialisation

    activate: (state) ->
        @emdeView = new EmdeView(state.emdeViewState)
        @subscriptions = new CompositeDisposable

        @messages = new MessagePanelView
            title: 'EMDE Status'

        @registerCommands()

    deactivate: ->
        @modelPanel.destroy()
        @subscriptions.dispose()
        @emdeView.destroy()
        @messages.destroy()

# This optional method is called when the window is shutting down. If your package is watching any files or holding external resources in any other way, release them here. If you're just subscribing to things on window, you don't need to worry because that's getting torn down anyway.

    serialize: ->
        emdeViewState: @emdeView.serialize()
# This optional method is called when the window is shutting down, allowing you to return JSON to represent the state of your component. When the window is later restored, the data you returned is passed to your module's activate method so you can restore your view to where the user left off.

    registerCommands: ->
        @subscriptions.add atom.commands.add 'atom-workspace',
            'emde:send-plain-text-selection': =>
                @sendPlainTextSelection()

            'emde:send-code-snippet': =>
                @sendCodeSnippet()

            'emde:send-markdown-file': =>
                @sendMarkdownFile()

            'emde:send-current-file': =>
                @sendCurrentFile()

            'emde:send-current-file-contents': =>
                @sendCurrentFileContents()

    sendPlainTextSelection: ->
        @messages.attach()
        @messages.summary.css('display', 'inline-block');
        @messages.body.css('display', 'none');

        # Get selection
        editor = atom.workspace.getActiveTextEditor()
        title = editor.getTitle()
        selection = editor.getSelectedText()

        if not !!selection
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Nothing selected, please select some text and try again.'
                className: 'text-warning'
            return

        # Send selection to evernote as new note
        note = new Note
            title: "Snippet #{title}"
            content: selection

        evernote = new Evernote()
        success = evernote.sendPlainTextSnippet(note)

        if not success
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Failed to send selection to Evernote'
                className: 'text-error'
            return

        @messages.clear()
        @messages.add new PlainMessageView
            raw: true
            message: "Succesfully sent snippet to Evernote in notebook <strong>#{note.notebook}</strong> with title <strong>#{note.title}</strong> and tags <strong>#{note.tags}</strong>"
            className: 'text-success'

    sendCodeSnippet: ->
        @messages.attach()
        @messages.summary.css('display', 'inline-block');
        @messages.body.css('display', 'none');

        # Get selection
        editor = atom.workspace.getActiveTextEditor()
        title = editor.getTitle()
        selection = editor.getSelectedText()

        if not !!selection
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Nothing selected, please select some text and try again.'
                className: 'text-warning'
            return

        # Send selection to evernote as new note
        note = new Note
            title: "Snippet #{title}"
            content: selection

        evernote = new Evernote()
        success = evernote.sendCodeSnippet(note)

        if not success
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Failed to send selection to Evernote'
                className: 'text-error'
            return

        @messages.clear()
        @messages.add new PlainMessageView
            raw: true
            message: "Succesfully sent code snippet to Evernote in notebook <strong>#{note.notebook}</strong> with title <strong>#{note.title}</strong> and tags <strong>#{note.tags}</strong>"
            className: 'text-success'

    sendCurrentFile: ->
        @messages.attach()
        @messages.summary.css('display', 'inline-block');
        @messages.body.css('display', 'none');

        # TODO: Prompt to save file before if file hasn't been saved.

        # Get selection
        editor = atom.workspace.getActiveTextEditor()
        title = editor.getTitle()

        if editor.isEmpty()
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Nothing to send.'
                className: 'text-warning'
            return

        filepath = editor.getPath()
        content = editor.getText()

        # Send selection to evernote as new note
        note = new Note
            title: "File: #{title}"
            filepath: filepath
            content: content

        evernote = new Evernote()
        success = evernote.sendCurrentFile(note)

        if not success
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Failed to send file to Evernote'
                className: 'text-error'
            return

        @messages.clear()
        @messages.add new PlainMessageView
            raw: true
            message: "Succesfully sent file to Evernote in notebook <strong>#{note.notebook}</strong> with title <strong>#{note.title}</strong> and tags <strong>#{note.tags}</strong>"
            className: 'text-success'

    sendMarkdownFile: ->
        @messages.attach()
        @messages.summary.css('display', 'inline-block');
        @messages.body.css('display', 'none');

        # Get selection
        editor = atom.workspace.getActiveTextEditor()
        title = editor.getTitle()

        if editor.isEmpty()
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Nothing to send.'
                className: 'text-warning'
            return

        filepath = editor.getPath()

        # Send selection to evernote as new note
        note = new Note
            title: "File: #{title}"
            filepath: filepath

        evernote = new Evernote()
        success = evernote.sendCurrentFile(note)

        if not success
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Failed to send file to Evernote'
                className: 'text-error'
            return

        @messages.clear()
        @messages.add new PlainMessageView
            raw: true
            message: "Succesfully sent file to Evernote in notebook <strong>#{note.notebook}</strong> with title <strong>#{note.title}</strong> and tags <strong>#{note.tags}</strong>"
            className: 'text-success'

    sendCurrentFileContents: ->
        @messages.attach()
        @messages.summary.css('display', 'inline-block');
        @messages.body.css('display', 'none');

        # Get selection
        editor = atom.workspace.getActiveTextEditor()
        title = editor.getTitle()

        if editor.isEmpty()
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Nothing to send.'
                className: 'text-warning'
            return

        filepath = editor.getPath()
        content = editor.getText()

        # Send selection to evernote as new note
        note = new Note
            title: "File: #{title}"
            filepath: filepath
            content: content

        evernote = new Evernote()
        success = evernote.sendCurrentFileContents(note)

        if not success
            @messages.clear()
            @messages.add new PlainMessageView
                message: 'Failed to send file to Evernote'
                className: 'text-error'
            return

        @messages.clear()
        @messages.add new PlainMessageView
            raw: true
            message: "Succesfully sent file to Evernote in notebook <strong>#{note.notebook}</strong> with title <strong>#{note.title}</strong> and tags <strong>#{note.tags}</strong>"
            className: 'text-success'

    consumeAutoreload: (reloader) ->
        reloader(pkg:"evernote-markdown-editor",files:["package.json"],folders:["lib/"])
