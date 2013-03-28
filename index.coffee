
# ## The Hint decorator
#
# This decorator puts a text over a label that fades out when the user selects the label, or edits the text.


KEYCODE_ESC = 27
KEYCODE_ENTER = 13

Formwatcher = require "formwatcher"


createElement = (string) ->
  div = document.createElement "div"
  div.innerHTML = string
  div.firstChild

Formwatcher.registerDecorator class extends Formwatcher.Decorator

  name: "Ace"
  description: "Turns a textarea into the ace editor."
  nodeNames: [ "TEXTAREA" ]
  classNames: [ "ace" ]

  defaultOptions:
    theme: null # Won't set a theme if null. This can also be set with the class name, eg: ace-theme-monokai
    mode: null # Won't set a mode if null. This can also be set with the class name, eg: ace-mode-css
    tabSize: 2
    softTabs: yes


  decorate: (input) ->
    elements = input: input

    input.style.display = "none"


    aceContainerElement = createElement """<div class="formwatcher-ace-container embedded"></div>"""
    aceElement = createElement """<div class="formwatcher-ace-editor"></div>"""

    aceElement.appendChild document.createTextNode input.value

    goFullScreenElement = createElement """<a href="javascript:undefined;" class="go-fullscreen">Go fullscreen (⌘ - ENTER , CTRL - ENTER)</a>"""
    exitFullScreenElement = createElement """<a href="javascript:undefined;" class="exit-fullscreen">Exit fullscreen (ESC)</a>"""

    aceContainerElement.appendChild aceElement
    aceContainerElement.appendChild goFullScreenElement
    aceContainerElement.appendChild exitFullScreenElement

    input.parentNode.insertBefore aceContainerElement, input.nextSibling

    elements.ace = aceElement

    editor = window.ace.edit aceElement
    editor.getSession().setTabSize @options.tabSize
    editor.getSession().setUseSoftTabs @options.softTabs

    mode = @options.mode
    for className in input.classList
      if modeMatch = /^ace\-mode\-(.+)/.exec className
        mode = modeMatch[1]

    theme = @options.theme
    for className in input.classList
      if themeMatch = /^ace\-theme\-(.+)/.exec className
        theme = themeMatch[1]

    editor.setTheme("ace/theme/#{theme}") if theme?
    editor.getSession().setMode("ace/mode/#{mode}") if mode?

    editor.getSession().on "change", (e) -> input.value = editor.getValue()


    exitFullscreenListener = (e) -> exitFullscreen() if e.keyCode == KEYCODE_ESC
    enterFullscreenListener = (e) ->
      if e.keyCode == KEYCODE_ENTER and (e.ctrlKey || e.metaKey)
        e.stopPropagation()
        e.preventDefault()
        goFullscreen() 

    # Now setup the fullscreen modes
    goFullscreen = ->
      document.addEventListener "keyup", exitFullscreenListener
      document.removeEventListener "keydown", enterFullscreenListener

      aceContainerElement.classList.add "fullscreen"
      aceContainerElement.classList.remove "embedded"

      editor.resize()

    exitFullscreen = ->
      document.addEventListener "keydown", enterFullscreenListener
      document.removeEventListener "keyup", exitFullscreenListener

      aceContainerElement.classList.add "embedded"
      aceContainerElement.classList.remove "fullscreen"

      editor.resize()


    goFullScreenElement.addEventListener "click", goFullscreen
    exitFullScreenElement.addEventListener "click", exitFullscreen

    exitFullscreen()



    elements
