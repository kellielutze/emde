fs              = require 'fs'
path            = require 'path'
temp            = require 'temp'

Note            = require ('./note')

module.exports = class Evernote
    constructor: ->
        root = path.resolve '/'
        @root_enScript_file = path.join root, 'Program Files (x86)/Evernote/Evernote/Evernote.exe'
        @root_exec_file = path.join root, 'Program Files (x86)/Evernote/Evernote/ENScript.exe'

        if @check() is false
            console.log 'Evernote configuration paths are invalid'

    sendPlainTextSnippet: (note)->
        tagsOuput = ''
        tagsOuput = tagsOuput + '/t "'+ tag + '" ' for tag in note.tags

        cmd = "\"#{@root_exec_file}\" createNote /n \"#{note.notebook}\" /i \"#{note.title}\" #{tagsOuput}"

        exec = require('child_process').exec
        child = exec cmd, (error, stdout, stderr) -> console.log stdout
        child.stdin.write note.content

        #  Ctrl-Z
        child.stdin.write('\x1A');
        child.stdin.write('\n');

        if child.stdout.read() is not null
            return false
        return true

    sendCodeSnippet: (note) ->
        if atom.inDevMode()
            console.log "Sending current snippet with title #{note.title}"
        # TODO 12/18/2016, 8:48:03 PM sendCodeSnippet
        # TODO 12/18/2016, 8:55:10 PM file type to be added to tags automatically
        # TODO 12/18/2016, 8:55:32 PM markdown code block to be used.
        # TODO 12/18/2016, 8:55:57 PM convert to temp enex and import

    ###
    Send the current file contents as plain text to evernote.
    ###
    sendCurrentFileContents: (note) ->
        if atom.inDevMode()
            console.log "Sending current file with path #{note.filepath}"

        # Automatically trsack and cleanup temp files on exit
        temp.track()

        # TODO temp files are not working, will need to create real files.

        fileName = path.basename(note.filepath) + ".txt"

        evernote = new Evernote()
        root_exec_file = @root_exec_file
        temp.open(fileName, (err, info) ->
            if not err
                fs.writeFile(fileName, note.content, (err) ->
                    if err
                        console.log "no!"
                        # TODO Error message on fail to write
                    else
                        console.log "Creating note"
                        note.filepath = info.path
                        if atom.inDevMode()
                            console.log "Sending current file with path #{note.filepath}"

                        tagsOuput = ''
                        tagsOuput = tagsOuput + '/t "'+ tag + '" ' for tag in note.tags

                        cmd = "\"#{root_exec_file}\" createNote /n \"#{note.notebook}\" /i \"#{note.title}\" #{tagsOuput} /s \"#{note.filepath}\""

                        exec = require('child_process').exec
                        child = exec cmd, (error, stdout, stderr) -> console.log stdout
                        child.stdin.write note.content
                        console.log "Note should be createde"

                        if atom.inDevMode()
                            console.log cmd

                        if child.stdout.read() is not null
                            return false
                        return true
                )
            else
                console.log "No!!"
                console.log err
                # TODO Error handling
        )
        return false


    sendCurrentFile: (note) ->
        if atom.inDevMode()
            console.log "Sending current file with path #{note.filepath}"

        tagsOuput = ''
        tagsOuput = tagsOuput + '/t "'+ tag + '" ' for tag in note.tags

        cmd = "\"#{@root_exec_file}\" createNote /n \"#{note.notebook}\" /i \"#{note.title}\" #{tagsOuput} /s \"#{note.filepath}\""

        exec = require('child_process').exec
        child = exec cmd, (error, stdout, stderr) -> console.log stdout
        child.stdin.write note.content

        if atom.inDevMode()
            console.log cmd

        if child.stdout.read() is not null
            return false
        return true

    sendMarkdownFile: (note) ->
        if atom.inDevMode()
            console.log "Sending current markdown file with path #{note.filepath}"

            # TODO 12/18/2016, 7:15:11 PM create temp .enex file with details from note
            # Maybe in dir ~/.atom/emde
            # TODO 12/18/2016, 7:15:58 PM  pass filename etc to evernote exect

    check: ->
        for p in [ @root_enScript_file, @root_exec_file ] then do ( p ) ->
            fs.exists p, ( p_exists ) ->
                unless p_exists
                    return false
                else
                    return true
