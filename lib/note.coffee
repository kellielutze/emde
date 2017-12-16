module.exports = class Note
    constructor: (note) ->

        now = new Date()
        now_formatted = formatDate(now);

        if note.title?
            @title = note.title
        else
            "emde Note: #{now_formatted}"

        if note.content?
            @content = note.content
        else
            @content = ''

        if note.tags?
            @tags = note.tags
            @tags.push('emde')
        else
            @tags = ['emde']

        if note.notebook?
            @notebook = note.notebook
        else
            @notebook = 'General'

        if note.date?
            @date = note.date
        else
            @date = new Date()

        if note.filepath?
            @filepath = note.filepath
        else
            @filepath = null

formatDate = (date) ->
  timeStamp = [date.getFullYear(), (date.getMonth() + 1), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()].join(" ")
  RE_findSingleDigits = /\b(\d)\b/g

  # Places a `0` in front of single digit numbers.
  timeStamp = timeStamp.replace( RE_findSingleDigits, "0$1" )
  timeStamp.replace /\s/g, ""
