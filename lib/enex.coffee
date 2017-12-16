###
Generate an ENEX file with the provided note details
###


fs              = require 'fs'
path            = require 'path'
temp            = require 'temp'

Note            = require ('./note')
Evernote        = require ('./evernote')

module.exports = class Enex
    constructor: ->
        # Automatically trsack and cleanup temp files on exit
        temp.track()

    ###
    Create an exex file from a simple plaintext note i.e. No Transforms
    ###
    createFromSimpleNote: (note) ->
        # tempName = temp.path(
        #     suffix: '.txt'
        # )
        #
        fileName = path.basename(note.filepath)
        evernote = new Evernote()

        temp.open(fileName + ".txt", (err, info) ->
            if not err
                fs.writeFile(fileName, note.content, (err) ->
                    if err
                        console.log "no!"
                        # TODO Error message on fail to write
                    else
                        console.log "Creating note"
                        note.path = info.path
                        success = @evernote.sendCurrentFile(note)
                )
            else
                console.log "No!!"
                console.log err
                # TODO Error handling
        )
        return
#TODO generate enex into temp file and return file path to temp enex

    ###
    Create enex file from code block or snippet. This requires syntax and simple codeblock wrapper. Option params include syntax etc.
    ###
    createFromCodeNote: (note) ->
        # TODO Create html code block for snippet and create enex file
        # then return the file path to the given file

    ###
    Create enex file from a markdown file, this requires a transform from Markdown -> Enex with any styles applied
    ###
    createFromMarkdownNote: (note) ->
        # TODO Transform Markdown to html
        # TODO Transform html to Enex
        # TODO Return filepath

    cleanUp: ->
        # TODO Clean up any tmp files created.
