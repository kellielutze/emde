module.exports =
class EvernoteMarkdownView
  constructor: (serializedState) ->

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('your-name-word-count')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The Your Name Word Count package is Alive! It's ALIVE!"
    message.classList.add('message')

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
